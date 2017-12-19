//
//  JanProxy.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "JanProxy.h"

@interface JanProxy ()

@property(nonatomic,strong) NSObject *objc;

@end

@implementation JanProxy

- (void)transformObjc:(NSObject *)objc{
    //复制对象
    self.objc = objc;
}

//2.有了方法签名之后就会调用方法实现
- (void)forwardInvocation:(NSInvocation *)invocation{
    if (self.objc) {
        //拦截方法的执行者为复制的对象
        [invocation setTarget:self.objc];
        
        if ([self.objc isKindOfClass:[NSClassFromString(@"Cat") class]]) {
            //拦截参数 Argument:表示的是方法的参数  index:表示的是方法参数的下标
            NSString *str = @"拦截消息";
            [invocation setArgument:&str atIndex:2];
        }
        //开始调用方法
        [invocation invoke];
    }
    
}

//1.查询该方法的方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    NSMethodSignature *signature = nil;
    if ([self.objc methodSignatureForSelector:sel]) {
        signature = [self.objc methodSignatureForSelector:sel];
    }
    else {
        signature = [super methodSignatureForSelector:sel];
    }
    return signature;
}



@end
