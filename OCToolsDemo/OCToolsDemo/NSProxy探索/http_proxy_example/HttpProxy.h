//
// Created by zorro on 15-1-20.
// Copyright (c) 2015 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHttpHandler.h"
#import "CommentHttpHandler.h"


/**
 *  Example
 *
 //初始化，注册Protocol对应的实现类对象
 [[HttpProxy sharedInstance] registerHttpProtocol:@protocol(UserHttpHandler) handler:[UserHttpHandlerImp new]];
 [[HttpProxy sharedInstance] registerHttpProtocol:@protocol(CommentHttpHandler) handler:[CommentHttpHandlerImp new]];
 
 //调用
 [[HttpProxy sharedInstance] getUserWithID:@100];
 [[HttpProxy sharedInstance] getCommentsWithDate:[NSDate new]];
 */

@interface HttpProxy : NSProxy <UserHttpHandler, CommentHttpHandler>

+ (instancetype)sharedInstance;

- (void)registerHttpProtocol:(Protocol *)httpProtocol handler:(id)handler;
@end
