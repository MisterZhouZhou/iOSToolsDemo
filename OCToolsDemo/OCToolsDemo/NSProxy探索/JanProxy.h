//
//  JanProxy.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JanProxy : NSProxy

- (void)transformObjc:(NSObject *)objc;

@end
