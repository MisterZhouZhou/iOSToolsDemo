//
//  NSKeyedUnarchiver+ZWAdd.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/5.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "NSKeyedUnarchiver+ZWAdd.h"
#import "ZWKitMacro.h"

ZWSYNTH_DUMMY_CLASS(NSKeyedUnarchiver_ZWAdd)

@implementation NSKeyedUnarchiver (ZWAdd)

+ (id)unarchiveObjectWithData:(NSData *)data exception:(__autoreleasing NSException **)exception {
    id object = nil;
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *e)
    {
    if (exception) *exception = e;
    }
    @finally
    {
    }
    return object;
}


+ (id)unarchiveObjectWithFile:(NSString *)path exception:(__autoreleasing NSException **)exception {
    id object = nil;
    
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    @catch (NSException *e)
    {
    if (exception) *exception = e;
    }
    @finally
    {
    }
    return object;
}

@end
