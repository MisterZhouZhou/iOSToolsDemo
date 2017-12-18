//
//  ZWSentinel.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/18.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ZWSentinel.h"
#import <libkern/OSAtomic.h>

@implementation ZWSentinel {
    int32_t _value;
}

- (int32_t)value {
    return _value;
}

- (int32_t)increase {
    return OSAtomicIncrement32(&_value);
}

@end
