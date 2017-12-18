//
//  ZWTextArchiver.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/12.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ZWTextArchiver.h"
#import "ZWTextRunDelegate.h"
#import "ZWTextRubyAnnotation.h"
#import "UIDevice+ZWAdd.h"

/**
 When call CTRunDelegateGetTypeID() on some devices (runs iOS6), I got the error:
 "dyld: lazy symbol binding failed: Symbol not found: _CTRunDelegateGetTypeID"
 
 Here's a workaround for this issue.
 */
static CFTypeID CTRunDelegateTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*
         if ((long)CTRunDelegateGetTypeID + 1 > 1) { //avoid compiler optimization
         typeID = CTRunDelegateGetTypeID();
         }
         */
        ZWTextRunDelegate *delegate = [ZWTextRunDelegate new];
        CTRunDelegateRef ref = delegate.CTRunDelegate;
        typeID = CFGetTypeID(ref);
        CFRelease(ref);
    });
    return typeID;
}

static CFTypeID CTRubyAnnotationTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((long)CTRubyAnnotationGetTypeID + 1 > 1) { //avoid compiler optimization
            typeID = CTRunDelegateGetTypeID();
        } else {
            typeID = kCFNotFound;
        }
    });
    return typeID;
}


/**
 A wrapper for CGColorRef. Used for Archive/Unarchive/Copy.
 */
@interface _ZWCGColor : NSObject <NSCopying, NSCoding>
@property (nonatomic, assign) CGColorRef CGColor;
+ (instancetype)colorWithCGColor:(CGColorRef)CGColor;
@end

@implementation _ZWCGColor

+ (instancetype)colorWithCGColor:(CGColorRef)CGColor {
    _ZWCGColor *color = [self new];
    color.CGColor = CGColor;
    return color;
}

- (void)setCGColor:(CGColorRef)CGColor {
    if (_CGColor != CGColor) {
        if (CGColor) CGColor = (CGColorRef)CFRetain(CGColor);
        if (_CGColor) CFRelease(_CGColor);
        _CGColor = CGColor;
    }
}

- (void)dealloc {
    if (_CGColor) CFRelease(_CGColor);
    _CGColor = NULL;
}

- (id)copyWithZone:(NSZone *)zone {
    _ZWCGColor *color = [self.class new];
    color.CGColor = self.CGColor;
    return color;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    UIColor *color = [UIColor colorWithCGColor:_CGColor];
    [aCoder encodeObject:color forKey:@"color"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    UIColor *color = [aDecoder decodeObjectForKey:@"color"];
    self.CGColor = color.CGColor;
    return self;
}

@end


/**
 A wrapper for CGImageRef. Used for Archive/Unarchive/Copy.
 */
@interface _ZWCGImage : NSObject <NSCoding, NSCopying>
@property (nonatomic, assign) CGImageRef CGImage;
+ (instancetype)imageWithCGImage:(CGImageRef)CGImage;
@end

@implementation _ZWCGImage

+ (instancetype)imageWithCGImage:(CGImageRef)CGImage {
    _ZWCGImage *image = [self new];
    image.CGImage = CGImage;
    return image;
}

- (void)setCGImage:(CGImageRef)CGImage {
    if (_CGImage != CGImage) {
        if (CGImage) CGImage = (CGImageRef)CFRetain(CGImage);
        if (_CGImage) CFRelease(_CGImage);
        _CGImage = CGImage;
    }
}

- (void)dealloc {
    if (_CGImage) CFRelease(_CGImage);
}

- (id)copyWithZone:(NSZone *)zone {
    _ZWCGImage *image = [self.class new];
    image.CGImage = self.CGImage;
    return image;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    UIImage *image = [UIImage imageWithCGImage:_CGImage];
    [aCoder encodeObject:image forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    UIImage *image = [aDecoder decodeObjectForKey:@"image"];
    self.CGImage = image.CGImage;
    return self;
}

@end


@implementation ZWTextArchiver

+ (NSData *)archivedDataWithRootObject:(id)rootObject {
    if (!rootObject) return nil;
    NSMutableData *data = [NSMutableData data];
    ZWTextArchiver *archiver = [[[self class] alloc] initForWritingWithMutableData:data];
    [archiver encodeRootObject:rootObject];
    [archiver finishEncoding];
    return data;
}

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path {
    NSData *data = [self archivedDataWithRootObject:rootObject];
    if (!data) return NO;
    return [data writeToFile:path atomically:YES];
}

- (instancetype)init {
    self = [super init];
    self.delegate = self;
    return self;
}

- (instancetype)initForWritingWithMutableData:(NSMutableData *)data {
    self = [super initForWritingWithMutableData:data];
    self.delegate = self;
    return self;
}

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
    CFTypeID typeID = CFGetTypeID((CFTypeRef)object);
    if (typeID == CTRunDelegateTypeID()) {
        CTRunDelegateRef runDelegate = (__bridge CFTypeRef)(object);
        id ref = CTRunDelegateGetRefCon(runDelegate);
        if (ref) return ref;
    } else if (typeID == CTRubyAnnotationTypeID()) {
        CTRubyAnnotationRef ctRuby = (__bridge CFTypeRef)(object);
        ZWTextRubyAnnotation *ruby = [ZWTextRubyAnnotation rubyWithCTRubyRef:ctRuby];
        if (ruby) return ruby;
    } else if (typeID == CGColorGetTypeID()) {
        return [_ZWCGColor colorWithCGColor:(CGColorRef)object];
    } else if (typeID == CGImageGetTypeID()) {
        return [_ZWCGImage imageWithCGImage:(CGImageRef)object];
    }
    return object;
}

@end



@implementation ZWTextUnarchiver

+ (id)unarchiveObjectWithData:(NSData *)data {
    if (data.length == 0) return nil;
    ZWTextUnarchiver *unarchiver = [[self alloc] initForReadingWithData:data];
    return [unarchiver decodeObject];
}

+ (id)unarchiveObjectWithFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self unarchiveObjectWithData:data];
}

- (instancetype)init {
    self = [super init];
    self.delegate = self;
    return self;
}

- (instancetype)initForReadingWithData:(NSData *)data {
    self = [super initForReadingWithData:data];
    self.delegate = self;
    return self;
}

- (id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id) NS_RELEASES_ARGUMENT object NS_RETURNS_RETAINED {
    if ([object class] == [ZWTextRunDelegate class]) {
        ZWTextRunDelegate *runDelegate = object;
        CTRunDelegateRef ct = runDelegate.CTRunDelegate;
        id ctObj = (__bridge id)ct;
        if (ct) CFRelease(ct);
        return ctObj;
    } else if ([object class] == [ZWTextRubyAnnotation class]) {
        ZWTextRubyAnnotation *ruby = object;
        if (kiOS8Later) {
            CTRubyAnnotationRef ct = ruby.CTRubyAnnotation;
            id ctObj = (__bridge id)(ct);
            if (ct) CFRelease(ct);
            return ctObj;
        } else {
            return object;
        }
    } else if ([object class] == [_ZWCGColor class]) {
        _ZWCGColor *color = object;
        return (id)color.CGColor;
    } else if ([object class] == [_ZWCGImage class]) {
        _ZWCGImage *image = object;
        return (id)image.CGImage;
    }
    return object;
}

@end
