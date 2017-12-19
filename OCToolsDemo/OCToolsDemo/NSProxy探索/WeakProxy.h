//
//  WeakProxy.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#warning 此处代码有问题

#import <Foundation/Foundation.h>

@interface WeakProxy : NSProxy

@property (weak,nonatomic,readonly)id target;

+ (instancetype)proxyWithTarget:(id)target;

- (instancetype)initWithTarget:(id)target;

@end
