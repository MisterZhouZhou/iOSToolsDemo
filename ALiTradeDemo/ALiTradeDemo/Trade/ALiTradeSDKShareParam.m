//
//  ALiTradeSDKShareParam.m
//  ALiTradeDemo
//
//  Created by chengfei on 2017/12/7.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ALiTradeSDKShareParam.h"
#import "ALiTradeDefine.h"

@implementation ALiTradeSDKShareParam

+ (instancetype)sharedInstance
{
    static ALiTradeSDKShareParam* instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ALiTradeSDKShareParam alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *taoKeDict = @{@"pid": DAILYTAOKEPID, //  淘客ID 阿里妈妈获取的
                                    @"unionId":@"",
                                    @"subPid":@"",
                                    @"adzoneId": DAILYTAOKEADZONEID,
                                    @"extParams":@{@"taokeAppkey":ALiTradeAppKey}
                                    };
        self.taoKeParams = [NSMutableDictionary dictionaryWithDictionary:taoKeDict];
        // 链路跟踪参数
        NSDictionary *customDict = @{@"pvid": @"hello",
                                 @"scm":@"world",
                                 @"page":@"vedio",
                                 @"subplat":@"baichuan",
                                 @"label":@"trade",
                                 @"puid":@"mister",
                                 @"pguid":@"zhou",
                                 };
        self.customParams = [NSMutableDictionary dictionaryWithDictionary:customDict];
        self.backUrl= [NSString stringWithFormat:@"tbopen%@",ALiTradeAppKey];
        self.openType= AlibcOpenTypeAuto; //AlibcOpenTypeAuto, AlibcOpenTypeAuto
        self.isNeedPush = NO;
        self.isBindWebview = YES;
        self.nativeFailMode = AlibcNativeFailModeJumpH5; //AlibcNativeFailModeJumpH5
        self.linkKey = @"taobao_scheme";
        self.isUseTaokeParam = NO;
    }
    return self;
}

@end
