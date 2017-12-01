//
//  NSNumber+ZWAdd.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/30.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide a method to parse `NSString` for `NSNumber`.
 */

@interface NSNumber (ZWAdd)

/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;


@end

NS_ASSUME_NONNULL_END

