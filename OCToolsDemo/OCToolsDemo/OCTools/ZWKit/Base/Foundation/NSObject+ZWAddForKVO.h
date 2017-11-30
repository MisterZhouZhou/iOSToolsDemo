//
//  NSObject+ZWAddForKVO.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/30.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

// 以block的形式监听值改变
NS_ASSUME_NONNULL_BEGIN

/**
 Observer with block (KVO).
 */
@interface NSObject (ZWAddForKVO)

/**
 Registers a block to receive KVO notifications for the specified key-path
 relative to the receiver.
 
 @discussion The block and block captured objects are retained. Call
 `removeObserverBlocksForKeyPath:` or `removeObserverBlocks` to release.
 
 @param keyPath The key path, relative to the receiver, of the property to
 observe. This value must not be nil.
 
 @param block   The block to register for KVO notifications.
 // example
    [person addObserverBlockForKeyPath:@"age" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
    NSLog(@"%@", obj);
    }];
 */
- (void)addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal))block;

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications for the property specified by a given key-path
 relative to the receiver, and release these blocks.
 
 @param keyPath A key-path, relative to the receiver, for which blocks is
 registered to receive KVO change notifications.
 */
- (void)removeObserverBlocksForKeyPath:(NSString*)keyPath;

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications, and release these blocks.
 */
- (void)removeObserverBlocks;


@end

NS_ASSUME_NONNULL_END
