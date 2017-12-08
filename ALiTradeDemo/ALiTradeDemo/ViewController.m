//
//  ViewController.m
//  ALiTradeDemo
//
//  Created by chengfei on 2017/12/7.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ViewController.h"
#import <AlibabaAuthSDK/albbsdk.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "MyAlertView.h"
#import "ALiTradeSDKShareParam.h"
#import "ALiTradeWebViewController.h"

@interface ViewController ()
@property(nonatomic, copy) loginSuccessCallback loginSuccessCallback;
@property(nonatomic, copy) loginFailureCallback loginFailedCallback;
@property (nonatomic, copy) AlibcTradeProcessSuccessCallback onTradeSuccess;
@property (nonatomic, copy) AlibcTradeProcessFailedCallback onTradeFailure;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(100, 100, 100, 40);
    loginBtn.backgroundColor = [UIColor blueColor];
    [loginBtn setTitle:@"淘宝登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
    UIButton *taoBaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    taoBaoBtn.frame = CGRectMake(100, 160, 100, 40);
    taoBaoBtn.backgroundColor = [UIColor blueColor];
    [taoBaoBtn setTitle:@"打开淘宝商品详情" forState:UIControlStateNormal];
    [taoBaoBtn addTarget:self action:@selector(openItemDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:taoBaoBtn];
    
    
    [self addTradeBlock];
}

#pragma mark - tradeblock
- (void)addTradeBlock{
    _loginSuccessCallback=^(ALBBSession *session){
        NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[session getUser]];
        [[MyAlertView alertViewWithTitle:@"登录成功" message:tip oALinClicked:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        // 进后台进行关联
        
        // 关联成功后进行商品跳转
    };
    
    _loginFailedCallback=^(ALBBSession *session, NSError *error){
        NSString *tip=[NSString stringWithFormat:@"登录失败:%@",@""];
        [[MyAlertView alertViewWithTitle:@"登录失败" message:tip oALinClicked:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
    };
    
    _onTradeSuccess=^(AlibcTradeResult *tradeProcessResult){
        if(tradeProcessResult.result ==AlibcTradeResultTypePaySuccess){
            NSString *tip=[NSString stringWithFormat:@"交易成功:成功的订单%@\n，失败的订单%@\n",[tradeProcessResult payResult].paySuccessOrders,[tradeProcessResult payResult].payFailedOrders];
            [[MyAlertView alertViewWithTitle:@"交易成功" message:tip oALinClicked:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        }else if(tradeProcessResult.result==AlibcTradeResultTypeAddCard){
            [[MyAlertView alertViewWithTitle:@"加入购物车" message:@"加入成功" oALinClicked:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        }
    };
    _onTradeFailure=^(NSError *error){
        //  退出交易流程
        if (error.code==AlibcErrorCancelled) {
            return ;
        }
        NSDictionary *infor=[error userInfo];
        NSArray*  orderid=[infor objectForKey:@"orderIdList"];
        NSString *tip=[NSString stringWithFormat:@"交易失败:\n订单号\n%@",orderid];
        [[MyAlertView alertViewWithTitle:@"交易失败" message:tip oALinClicked:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
    };
}

-(AlibcTradeTaokeParams*)taokeParam{
    if ([ALiTradeSDKShareParam sharedInstance].isUseTaokeParam) {
        AlibcTradeTaokeParams *taoke = [[AlibcTradeTaokeParams alloc] init];
        taoke.pid =[[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"pid"];
        taoke.subPid = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"subPid"];
        taoke.unionId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"unionId"];
        taoke.adzoneId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"adzoneId"];
        taoke.extParams = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"extParams"];
        return taoke;
    } else {
        return nil;
    }
}

-(NSDictionary *)customParam{
    NSDictionary *customParam=[NSDictionary dictionaryWithDictionary:[ALiTradeSDKShareParam sharedInstance].customParams];
    return customParam;
    
}

#pragma mark - 淘宝商品详情
- (void)openItemDetailWithPage:(NSString *)detailPage{
    // 商品id
    //19682364508
    // 41576306115
    //根据链接打开页面
    id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage:detailPage];
    [self OpenByPage:page];
}

- (void)OpenByPage:(id<AlibcTradePage>)page
{
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    // 打开详情的方式
    showParam.openType = [ALiTradeSDKShareParam sharedInstance].openType;
    showParam.backUrl  = [ALiTradeSDKShareParam sharedInstance].backUrl;
    BOOL isNeedPush    = [ALiTradeSDKShareParam sharedInstance].isNeedPush;
    BOOL isBindWebview = [ALiTradeSDKShareParam sharedInstance].isBindWebview;
    showParam.isNeedPush = isNeedPush;
    showParam.nativeFailMode = [ALiTradeSDKShareParam sharedInstance].nativeFailMode;
    showParam.linkKey = [ALiTradeSDKShareParam sharedInstance].linkKey;
    if (isBindWebview) {
        ALiTradeWebViewController* view = [[ALiTradeWebViewController alloc] init];
        NSInteger res = [[AlibcTradeSDK sharedInstance].tradeService show:view webView:view.webView page:page showParams:showParam taoKeParams:[self taokeParam] trackParam:[self customParam] tradeProcessSuccessCallback:self.onTradeSuccess tradeProcessFailedCallback:self.onTradeFailure];
        if (res == 1) {
            [self.navigationController pushViewController:view animated:YES];
        }
    } else {
        if (isNeedPush) {
            [[AlibcTradeSDK sharedInstance].tradeService show:self.navigationController page:page showParams:showParam taoKeParams:[self taokeParam] trackParam:[self customParam] tradeProcessSuccessCallback:self.onTradeSuccess tradeProcessFailedCallback: self.onTradeFailure];
        } else {
            [[AlibcTradeSDK sharedInstance].tradeService show:self page:page showParams:showParam taoKeParams:[self taokeParam] trackParam:[self customParam] tradeProcessSuccessCallback:self.onTradeSuccess tradeProcessFailedCallback: self.onTradeFailure];
        }
        
    }
}

#pragma mark - 淘宝登录
- (void)loginClick{
    if(![[ALBBSession sharedInstance] isLogin]){
        [[ALBBSDK sharedInstance] auth:self successCallback:_loginSuccessCallback failureCallback:_loginFailedCallback];
    }else{
        [[ALBBSDK sharedInstance] logout];
        ALBBSession *session=[ALBBSession sharedInstance];
        NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[[session getUser] ALBBUserDescription]];
        NSLog(@"%@", tip);
        [[MyAlertView alertViewWithTitle:@"登录成功" message:tip oALinClicked:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
    }
}


#pragma mark - 打开淘宝详情
- (void)openItemDetail{
    [self openItemDetailWithPage:@"19682364508"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
