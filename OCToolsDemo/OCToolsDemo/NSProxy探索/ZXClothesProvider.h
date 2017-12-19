//
//  ZXClothesProvider.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ZXClothesSize){
    ZXClothesSizeSmall=0,
    ZXClothesSizeMedium,
    ZXClothesSizeLarge
};
@protocol ZXClothesProviderProtocol

-(void)purchaseClothesWithSize:(ZXClothesSize)size;

@end

@interface ZXClothesProvider : NSObject

@end
