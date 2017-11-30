//
//  NSObject+performSelector.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/30.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
// 设置非空参数
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (performSelector)

- (nullable id)performSelector:(SEL)aSelector withTheObjects:(NSArray*)objects;

- (nullable id)performSelectorWithTheArgs:(SEL)sel, ...;

@end
NS_ASSUME_NONNULL_END
