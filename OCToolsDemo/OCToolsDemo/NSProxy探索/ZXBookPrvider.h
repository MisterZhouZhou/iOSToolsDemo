//
//  ZXBookPrvider.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZXBookProviderProtocol

-(void)purchaseBookWithTitle:(NSString *)bookTitle;

@end

@interface ZXBookPrvider : NSObject

@end
