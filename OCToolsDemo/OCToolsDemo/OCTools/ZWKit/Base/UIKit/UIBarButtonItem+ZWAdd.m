//
//  UIBarButtonItem+ZWAdd.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/7.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "UIBarButtonItem+ZWAdd.h"
#import "ZWKitMacro.h"
#import <objc/runtime.h>

ZWSYNTH_DUMMY_CLASS(UIBarButtonItem_ZWAdd)


static const int block_key;

@interface _ZWUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _ZWUIBarButtonItemBlockTarget

- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) self.block(sender);
}

@end


@implementation UIBarButtonItem (ZWAdd)

- (void)setActionBlock:(void (^)(id sender))block {
    _ZWUIBarButtonItemBlockTarget *target = [[_ZWUIBarButtonItemBlockTarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &block_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id)) actionBlock {
    _ZWUIBarButtonItemBlockTarget *target = objc_getAssociatedObject(self, &block_key);
    return target.block;
}
@end
