//
//  ZWTextDebugOption.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/14.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ZWTextDebugOption.h"
#import "ZWKitMacro.h"
#import "UIColor+ZWAdd.h"
#import "ZWWeakProxy.h"


static pthread_mutex_t _sharedDebugLock;
static CFMutableSetRef _sharedDebugTargets = nil;
static ZWTextDebugOption *_sharedDebugOption = nil;

static const void* _sharedDebugSetRetain(CFAllocatorRef allocator, const void *value) {
    return value;
}

static void _sharedDebugSetRelease(CFAllocatorRef allocator, const void *value) {
}

void _sharedDebugSetFunction(const void *value, void *context) {
    id<ZWTextDebugTarget> target = (__bridge id<ZWTextDebugTarget>)(value);
    [target setDebugOption:_sharedDebugOption];
}

static void _initSharedDebug() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_mutex_init(&_sharedDebugLock, NULL);
        CFSetCallBacks callbacks = kCFTypeSetCallBacks;
        callbacks.retain = _sharedDebugSetRetain;
        callbacks.release = _sharedDebugSetRelease;
        _sharedDebugTargets = CFSetCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
    });
}

static void _setSharedDebugOption(ZWTextDebugOption *option) {
    _initSharedDebug();
    pthread_mutex_lock(&_sharedDebugLock);
    _sharedDebugOption = option.copy;
    CFSetApplyFunction(_sharedDebugTargets, _sharedDebugSetFunction, NULL);
    pthread_mutex_unlock(&_sharedDebugLock);
}

static ZWTextDebugOption *_getSharedDebugOption() {
    _initSharedDebug();
    pthread_mutex_lock(&_sharedDebugLock);
    ZWTextDebugOption *op = _sharedDebugOption;
    pthread_mutex_unlock(&_sharedDebugLock);
    return op;
}

static void _addDebugTarget(id<ZWTextDebugTarget> target) {
    _initSharedDebug();
    pthread_mutex_lock(&_sharedDebugLock);
    CFSetAddValue(_sharedDebugTargets, (__bridge const void *)(target));
    pthread_mutex_unlock(&_sharedDebugLock);
}

static void _removeDebugTarget(id<ZWTextDebugTarget> target) {
    _initSharedDebug();
    pthread_mutex_lock(&_sharedDebugLock);
    CFSetRemoveValue(_sharedDebugTargets, (__bridge const void *)(target));
    pthread_mutex_unlock(&_sharedDebugLock);
}


@implementation ZWTextDebugOption

- (id)copyWithZone:(NSZone *)zone {
    ZWTextDebugOption *op = [self.class new];
    op.baselineColor = self.baselineColor;
    op.CTFrameBorderColor = self.CTFrameBorderColor;
    op.CTFrameFillColor = self.CTFrameFillColor;
    op.CTLineBorderColor = self.CTLineBorderColor;
    op.CTLineFillColor = self.CTLineFillColor;
    op.CTLineNumberColor = self.CTLineNumberColor;
    op.CTRunBorderColor = self.CTRunBorderColor;
    op.CTRunFillColor = self.CTRunFillColor;
    op.CTRunNumberColor = self.CTRunNumberColor;
    op.CGGlyphBorderColor = self.CGGlyphBorderColor;
    op.CGGlyphFillColor = self.CGGlyphFillColor;
    return op;
}

- (BOOL)needDrawDebug {
    if (self.baselineColor ||
        self.CTFrameBorderColor ||
        self.CTFrameFillColor ||
        self.CTLineBorderColor ||
        self.CTLineFillColor ||
        self.CTLineNumberColor ||
        self.CTRunBorderColor ||
        self.CTRunFillColor ||
        self.CTRunNumberColor ||
        self.CGGlyphBorderColor ||
        self.CGGlyphFillColor) return YES;
    return NO;
}

- (void)clear {
    self.baselineColor = nil;
    self.CTFrameBorderColor = nil;
    self.CTFrameFillColor = nil;
    self.CTLineBorderColor = nil;
    self.CTLineFillColor = nil;
    self.CTLineNumberColor = nil;
    self.CTRunBorderColor = nil;
    self.CTRunFillColor = nil;
    self.CTRunNumberColor = nil;
    self.CGGlyphBorderColor = nil;
    self.CGGlyphFillColor = nil;
}

+ (void)addDebugTarget:(id<ZWTextDebugTarget>)target {
    if (target) _addDebugTarget(target);
}

+ (void)removeDebugTarget:(id<ZWTextDebugTarget>)target {
    if (target) _removeDebugTarget(target);
}

+ (ZWTextDebugOption *)sharedDebugOption {
    return _getSharedDebugOption();
}

+ (void)setSharedDebugOption:(ZWTextDebugOption *)option {
    ZWAssertMainThread();
    _setSharedDebugOption(option);
}

@end
