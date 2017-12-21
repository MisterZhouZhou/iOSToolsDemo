//
//  ZWThreadSafeArray.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/20.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A simple implementation of thread safe mutable array.
 
 @discussion Generally, access performance is lower than NSMutableArray,
 but higher than using @synchronized, NSLock, or pthread_mutex_t.
 
 @discussion It's also compatible with the custom methods in `NSArray(YYAdd)`
 and `NSMutableArray(YYAdd)`
 
 @warning Fast enumerate(for..in) and enumerator is not thread safe,
 use enumerate using block instead. When enumerate or sort with block/callback,
 do *NOT* send message to the array inside the block/callback.
 */
@interface ZWThreadSafeArray : NSMutableArray

@end
