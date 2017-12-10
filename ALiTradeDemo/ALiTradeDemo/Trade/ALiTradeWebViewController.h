//
//  ALiTradeWantViewController.h
//  ALiSDKAPIDemo
//
//  Created by chengfei on 2017/12/7.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ALiTradeWebViewController : UIViewController<UIWebViewDelegate, NSURLConnectionDelegate>
/**
  商品链接地址
 */
@property (nonatomic, copy) NSString *openUrl;
/**
 webview
 */
@property (strong, nonatomic) UIWebView *webView;

-(UIWebView *)getWebView;

@end
