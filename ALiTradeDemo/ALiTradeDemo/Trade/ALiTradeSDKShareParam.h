//
//  ALiTradeSDKShareParam.h
//  ALiTradeDemo
//
//  Created by chengfei on 2017/12/7.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface ALiTradeSDKShareParam : NSObject

/**
 商品详情打开方式
// AlibcOpenTypeAuto;   自动
// AlibcOpenTypeNative; 手淘
// AlibcOpenTypeH5;     H5
*/
@property (nonatomic, assign) AlibcOpenType openType;
/**
 淘宝回调地址
 */
@property (nonatomic, copy) NSString *backUrl;
/**
  是否以push方式打开,默认为present
 */
@property (nonatomic, assign) BOOL isNeedPush;
/**
 *  是否绑定webview,内部webview或者sdk自带
 */
@property (nonatomic, assign) BOOL isBindWebview;
/**
 *  跳手淘/天猫失败后的处理策略, 默认值为: AlibcNativeFailModeJumpH5
 */
@property (nonatomic, assign) AlibcNativeFailMode nativeFailMode;
/**
 * applink使用，优先拉起的linkKey，手淘：@"taobao_scheme", 天猫： @"tmall_scheme"
 */
@property (nonatomic, copy) NSString *linkKey;
/**
 * 是否使用淘客参数
 */
@property (nonatomic, assign) BOOL isUseTaokeParam;
/**
 * 淘客参数
 */
@property(nonatomic,strong) NSMutableDictionary* taoKeParams;
/**
 * 自定义参数
 */
@property(nonatomic,strong) NSMutableDictionary* customParams;
/**
 单例
 */
+ (instancetype)sharedInstance;

@end
