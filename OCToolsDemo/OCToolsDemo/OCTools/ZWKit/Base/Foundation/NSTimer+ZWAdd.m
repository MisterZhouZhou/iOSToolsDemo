//
//  NSTimer+ZWAdd.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/5.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "NSTimer+ZWAdd.h"
#import "ZWKitMacro.h"

ZWSYNTH_DUMMY_CLASS(NSTimer_ZWAdd)


@implementation NSTimer (ZWAdd)

+ (void)_zw_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_zw_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_zw_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end
