//
//  NSThread+ZWAdd.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/6.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "NSThread+ZWAdd.h"
#import <CoreFoundation/CoreFoundation.h>

@interface NSThread_ZWAdd : NSObject @end
@implementation NSThread_ZWAdd @end

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif

static NSString *const ZWNSThreadAutoleasePoolKey = @"ZWNSThreadAutoleasePoolKey";
static NSString *const ZWNSThreadAutoleasePoolStackKey = @"ZWNSThreadAutoleasePoolStackKey";

static const void *PoolStackRetainCallBack(CFAllocatorRef allocator, const void *value) {
    return value;
}

static void PoolStackReleaseCallBack(CFAllocatorRef allocator, const void *value) {
    CFRelease((CFTypeRef)value);
}

static inline void ZWAutoreleasePoolPush() {
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[ZWNSThreadAutoleasePoolStackKey];
    
    if (!poolStack) {
        /*
         do not retain pool on push,
         but release on pop to avoid memory analyze warning
         */
        CFArrayCallBacks callbacks = {0};
        callbacks.retain = PoolStackRetainCallBack;
        callbacks.release = PoolStackReleaseCallBack;
        poolStack = (id)CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
        dic[ZWNSThreadAutoleasePoolStackKey] = poolStack;
        CFRelease(poolStack);
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // create
    [poolStack addObject:pool]; // push
}

static inline void ZWAutoreleasePoolPop() {
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[ZWNSThreadAutoleasePoolStackKey];
    [poolStack removeLastObject]; // pop
}

static void ZWRunLoopAutoreleasePoolObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry: {
            ZWAutoreleasePoolPush();
        } break;
        case kCFRunLoopBeforeWaiting: {
            ZWAutoreleasePoolPop();
            ZWAutoreleasePoolPush();
        } break;
        case kCFRunLoopExit: {
            ZWAutoreleasePoolPop();
        } break;
        default: break;
    }
}

#pragma mark - 初始化runloop监听者
static void ZWRunloopAutoreleasePoolSetup() {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    CFRunLoopObserverRef pushObserver;
    pushObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopEntry,
                                           true,         // repeat
                                           -0x7FFFFFFF,  // before other observers
                                           ZWRunLoopAutoreleasePoolObserverCallBack, NULL);
    CFRunLoopAddObserver(runloop, pushObserver, kCFRunLoopCommonModes);
    CFRelease(pushObserver);
    
    CFRunLoopObserverRef popObserver;
    popObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                          true,        // repeat
                                          0x7FFFFFFF,  // after other observers
                                          ZWRunLoopAutoreleasePoolObserverCallBack, NULL);
    CFRunLoopAddObserver(runloop, popObserver, kCFRunLoopCommonModes);
    CFRelease(popObserver);
}


@implementation NSThread (ZWAdd)

+ (void)addAutoreleasePoolToCurrentRunloop {
    if ([NSThread isMainThread]) return; // The main thread already has autorelease pool.
    NSThread *thread = [self currentThread];
    if (!thread) return;
    if (thread.threadDictionary[ZWNSThreadAutoleasePoolKey]) return; // already added
    ZWRunloopAutoreleasePoolSetup();
    thread.threadDictionary[ZWNSThreadAutoleasePoolKey] = ZWNSThreadAutoleasePoolKey; // mark the state
}

@end
