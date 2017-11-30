//
//  NSObject+ZWAddForKVO.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/30.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "NSObject+ZWAddForKVO.h"
#import "ZWKitMacro.h"
#import <objc/objc.h>
#import <objc/runtime.h>

ZWSYNTH_DUMMY_CLASS(NSObject_ZWAddForKVO)


static const int block_key;

@interface _ZWNSObjectKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation _ZWNSObjectKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
     if (!self.block) return;
     BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
     if (isPrior) return;
     NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
     if (changeKind != NSKeyValueChangeSetting) return;
    
     id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
     if (oldVal == [NSNull null]) oldVal = nil;
    
     id newVal = [change objectForKey:NSKeyValueChangeNewKey];
     if (newVal == [NSNull null]) newVal = nil;
    
     self.block(object, oldVal, newVal);
}

@end

@implementation NSObject (ZWAddForKVO)

- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block {
    if (!keyPath || !block) return;
    _ZWNSObjectKVOBlockTarget *target = [[_ZWNSObjectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self _zw_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *dic = [self _zw_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
}

- (void)removeObserverBlocks {
    NSMutableDictionary *dic = [self _zw_allNSObjectObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    
    [dic removeAllObjects];
}


- (NSMutableDictionary *)_zw_allNSObjectObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
