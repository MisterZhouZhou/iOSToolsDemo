//
//  UIPasteboard+ZWText.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/18.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "UIPasteboard+ZWText.h"
#import "ZWKitMacro.h"
#import "ZWImage.h"
#import "NSAttributedString+ZWText.h"
#import <MobileCoreServices/MobileCoreServices.h>

ZWSYNTH_DUMMY_CLASS(UIPasteboard_ZWText)

NSString *const ZWPasteboardTypeAttributedString = @"com.ibireme.NSAttributedString";
NSString *const ZWUTTypeWEBP = @"com.google.webp";

@implementation UIPasteboard (YYText)


- (void)setPNGData:(NSData *)PNGData {
    [self setData:PNGData forPasteboardType:(id)kUTTypePNG];
}

- (NSData *)PNGData {
    return [self dataForPasteboardType:(id)kUTTypePNG];
}

- (void)setJPEGData:(NSData *)JPEGData {
    [self setData:JPEGData forPasteboardType:(id)kUTTypeJPEG];
}

- (NSData *)JPEGData {
    return [self dataForPasteboardType:(id)kUTTypeJPEG];
}

- (void)setGIFData:(NSData *)GIFData {
    [self setData:GIFData forPasteboardType:(id)kUTTypeGIF];
}

- (NSData *)GIFData {
    return [self dataForPasteboardType:(id)kUTTypeGIF];
}

- (void)setWEBPData:(NSData *)WEBPData {
    [self setData:WEBPData forPasteboardType:ZWUTTypeWEBP];
}

- (NSData *)WEBPData {
    return [self dataForPasteboardType:ZWUTTypeWEBP];
}

- (void)setImageData:(NSData *)imageData {
    [self setData:imageData forPasteboardType:(id)kUTTypeImage];
}

- (NSData *)imageData {
    return [self dataForPasteboardType:(id)kUTTypeImage];
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    self.string = [attributedString plainTextForRange:NSMakeRange(0, attributedString.length)];
    NSData *data = [attributedString archiveToData];
    if (data) {
        NSDictionary *item = @{ZWPasteboardTypeAttributedString : data};
        [self addItems:@[item]];
    }
    [attributedString enumerateAttribute:ZWTextAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(ZWTextAttachment *attachment, NSRange range, BOOL *stop) {
        UIImage *img = attachment.content;
        if ([img isKindOfClass:[UIImage class]]) {
            NSDictionary *item = @{@"com.apple.uikit.image" : img};
            [self addItems:@[item]];
            
            
            if ([img isKindOfClass:[ZWImage class]] && ((ZWImage *)img).animatedImageData) {
                if (((ZWImage *)img).animatedImageType == ZWImageTypeGIF) {
                    NSDictionary *item = @{(id)kUTTypeGIF : ((ZWImage *)img).animatedImageData};
                    [self addItems:@[item]];
                } else if (((ZWImage *)img).animatedImageType == ZWImageTypePNG) {
                    NSDictionary *item = @{(id)kUTTypePNG : ((ZWImage *)img).animatedImageData};
                    [self addItems:@[item]];
                } else if (((ZWImage *)img).animatedImageType == ZWImageTypeWebP) {
                    NSDictionary *item = @{(id)ZWUTTypeWEBP : ((ZWImage *)img).animatedImageData};
                    [self addItems:@[item]];
                }
            }
            
            
            // save image
            UIImage *simpleImage = nil;
            if ([attachment.content isKindOfClass:[UIImage class]]) {
                simpleImage = attachment.content;
            } else if ([attachment.content isKindOfClass:[UIImageView class]]) {
                simpleImage = ((UIImageView *)attachment.content).image;
            }
            if (simpleImage) {
                NSDictionary *item = @{@"com.apple.uikit.image" : simpleImage};
                [self addItems:@[item]];
            }
            
            // save animated image
            if ([attachment.content isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = attachment.content;
                ZWImage *image = (id)imageView.image;
                if ([image isKindOfClass:[ZWImage class]]) {
                    NSData *data = image.animatedImageData;
                    ZWImageType type = image.animatedImageType;
                    if (data) {
                        switch (type) {
                            case ZWImageTypeGIF: {
                                NSDictionary *item = @{(id)kUTTypeGIF : data};
                                [self addItems:@[item]];
                            } break;
                            case ZWImageTypePNG: { // APNG
                                NSDictionary *item = @{(id)kUTTypePNG : data};
                                [self addItems:@[item]];
                            } break;
                            case ZWImageTypeWebP: {
                                NSDictionary *item = @{(id)ZWUTTypeWEBP : data};
                                [self addItems:@[item]];
                            } break;
                            default: break;
                        }
                    }
                }
            }
            
        }
    }];
}

- (NSAttributedString *)attributedString {
    for (NSDictionary *items in self.items) {
        NSData *data = items[ZWPasteboardTypeAttributedString];
        if (data) {
            return [NSAttributedString unarchiveFromData:data];
        }
    }
    return nil;
}

@end
