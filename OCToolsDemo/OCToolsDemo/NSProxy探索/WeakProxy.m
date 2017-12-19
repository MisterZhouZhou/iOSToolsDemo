//
//  WeakProxy.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "WeakProxy.h"

@implementation WeakProxy

#pragma mark - init
- (instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target{
    return [[self alloc] initWithTarget:target];
}

#pragma mark - implementation
- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = [invocation selector];
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }else{
        [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if([self.target respondsToSelector:aSelector]){
        return [self.target methodSignatureForSelector:aSelector];
    }else{
        return [super methodSignatureForSelector:aSelector];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    return [self.target respondsToSelector:aSelector];
}

@end
