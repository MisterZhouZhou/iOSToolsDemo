//
//  NSObject+ZWAddForARC.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/30.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "NSObject+ZWAddForARC.h"
#import "ZWKitMacro.h"

ZWSYNTH_DUMMY_CLASS(NSObject_ZWAddForARC);

// 使用非ARC模式
// 检测是否是arc
#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif

@implementation NSObject (ZWAddForARC)

- (instancetype)arcDebugRetain {
    return [self retain];
}

- (oneway void)arcDebugRelease {
    [self release];
}

- (instancetype)arcDebugAutorelease {
    return [self autorelease];
}

- (NSUInteger)arcDebugRetainCount {
    return [self retainCount];
}

@end
