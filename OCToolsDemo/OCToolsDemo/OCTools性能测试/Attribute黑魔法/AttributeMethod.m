//
//  AttributeMethod.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/11.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "AttributeMethod.h"

@implementation AttributeMethod

#pragma mark - property
- (void)useCleanUp{
    NSString *str __attribute__((cleanup(currentCleanUP))) = @"hello world!";
    NSLog(@"%@", str);
}

#pragma mark - block
- (void)createBlock{
    __strong void(^block)(void) __attribute__((cleanup(blockCleanup))) = ^{
        NSLog(@"Call Block");
    };
    block();
}


// 指定一个cleanup方法，注意入参是所修饰变量的地址，类型要一样
// 对于指向objc对象的指针(id *)，如果不强制声明__strong默认是__autoreleasing，造成类型不匹配
static void currentCleanUP(__strong NSObject **xcode){
    NSLog(@"cleanUp call:%@",*xcode);
}


static void blockCleanup(__strong void(^*block)(void)){
    // (*block)();  // 在释放的使用调用
    NSLog(@"block释放了");
}

@end
