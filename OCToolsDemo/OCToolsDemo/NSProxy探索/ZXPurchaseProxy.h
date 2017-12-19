//
//  ZXPurchaseProxy.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZXClothesProvider.h"
#import "ZXBookPrvider.h"

@interface ZXPurchaseProxy : NSProxy<ZXBookProviderProtocol,ZXClothesProviderProtocol>

+(instancetype)gainProxy;  

@end
