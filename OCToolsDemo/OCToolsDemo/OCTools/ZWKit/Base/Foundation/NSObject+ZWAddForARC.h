//
//  NSObject+ZWAddForARC.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/30.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Debug method for NSObject when using ARC.
 */
@interface NSObject (ZWAddForARC)

/// Same as `retain`
- (instancetype)arcDebugRetain;

/// Same as `release`
- (oneway void)arcDebugRelease;

/// Same as `autorelease`
- (instancetype)arcDebugAutorelease;

/// Same as `retainCount`
- (NSUInteger)arcDebugRetainCount;

@end
