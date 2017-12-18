//
//  ZWTextInput.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/14.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ZWTextInput.h"
#import "ZWKitMacro.h"

@implementation ZWTextPosition

+ (instancetype)positionWithOffset:(NSInteger)offset {
    return [self positionWithOffset:offset affinity:ZWTextAffinityForward];
}

+ (instancetype)positionWithOffset:(NSInteger)offset affinity:(ZWTextAffinity)affinity {
    ZWTextPosition *p = [self new];
    p->_offset = offset;
    p->_affinity = affinity;
    return p;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self.class positionWithOffset:_offset affinity:_affinity];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> (%@%@)", self.class, self, @(_offset), _affinity == ZWTextAffinityForward ? @"F":@"B"];
}

- (NSUInteger)hash {
    return _offset * 2 + (_affinity == ZWTextAffinityForward ? 1 : 0);
}

- (BOOL)isEqual:(ZWTextPosition *)object {
    if (!object) return NO;
    return _offset == object.offset && _affinity == object.affinity;
}

- (NSComparisonResult)compare:(ZWTextPosition *)otherPosition {
    if (!otherPosition) return NSOrderedAscending;
    if (_offset < otherPosition.offset) return NSOrderedAscending;
    if (_offset > otherPosition.offset) return NSOrderedDescending;
    if (_affinity == ZWTextAffinityBackward && otherPosition.affinity == ZWTextAffinityForward) return NSOrderedAscending;
    if (_affinity == ZWTextAffinityForward && otherPosition.affinity == ZWTextAffinityBackward) return NSOrderedDescending;
    return NSOrderedSame;
}

@end



@implementation ZWTextRange {
    ZWTextPosition *_start;
    ZWTextPosition *_end;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _start = [ZWTextPosition positionWithOffset:0];
    _end = [ZWTextPosition positionWithOffset:0];
    return self;
}

- (ZWTextPosition *)start {
    return _start;
}

- (ZWTextPosition *)end {
    return _end;
}

- (BOOL)isEmpty {
    return _start.offset == _end.offset;
}

- (NSRange)asRange {
    return NSMakeRange(_start.offset, _end.offset - _start.offset);
}

+ (instancetype)rangeWithRange:(NSRange)range {
    return [self rangeWithRange:range affinity:ZWTextAffinityForward];
}

+ (instancetype)rangeWithRange:(NSRange)range affinity:(ZWTextAffinity)affinity {
    ZWTextPosition *start = [ZWTextPosition positionWithOffset:range.location affinity:affinity];
    ZWTextPosition *end = [ZWTextPosition positionWithOffset:range.location + range.length affinity:affinity];
    return [self rangeWithStart:start end:end];
}

+ (instancetype)rangeWithStart:(ZWTextPosition *)start end:(ZWTextPosition *)end {
    if (!start || !end) return nil;
    if ([start compare:end] == NSOrderedDescending) {
        ZW_SWAP(start, end);
    }
    ZWTextRange *range = [ZWTextRange new];
    range->_start = start;
    range->_end = end;
    return range;
}

+ (instancetype)defaultRange {
    return [self new];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self.class rangeWithStart:_start end:_end];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> (%@, %@)%@", self.class, self, @(_start.offset), @(_end.offset - _start.offset), _end.affinity == ZWTextAffinityForward ? @"F":@"B"];
}

- (NSUInteger)hash {
    return (sizeof(NSUInteger) == 8 ? OSSwapInt64(_start.hash) : OSSwapInt32(_start.hash)) + _end.hash;
}

- (BOOL)isEqual:(ZWTextRange *)object {
    if (!object) return NO;
    return [_start isEqual:object.start] && [_end isEqual:object.end];
}

@end



@implementation ZWTextSelectionRect

@synthesize rect = _rect;
@synthesize writingDirection = _writingDirection;
@synthesize containsStart = _containsStart;
@synthesize containsEnd = _containsEnd;
@synthesize isVertical = _isVertical;

- (id)copyWithZone:(NSZone *)zone {
    ZWTextSelectionRect *one = [self.class new];
    one.rect = _rect;
    one.writingDirection = _writingDirection;
    one.containsStart = _containsStart;
    one.containsEnd = _containsEnd;
    one.isVertical = _isVertical;
    return one;
}

@end
