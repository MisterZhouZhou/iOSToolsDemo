//
//  ZWSentinel.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/18.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/**
 YYSentinel is a thread safe incrementing counter.
 It may be used in some multi-threaded situation.
 */
@interface ZWSentinel : NSObject

/// Returns the current value of the counter.
@property (readonly) int32_t value;

/// Increase the value atomically.
/// @return The new value.
- (int32_t)increase;

@end

NS_ASSUME_NONNULL_END
