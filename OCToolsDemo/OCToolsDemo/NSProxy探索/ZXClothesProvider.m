//
//  ZXClothesProvider.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ZXClothesProvider.h"

@implementation ZXClothesProvider

-(void)purchaseClothesWithSize:(ZXClothesSize)size
{
    NSString * string=nil;
    switch (size) {
        case ZXClothesSizeSmall:
            string=@"small size";
            break;
        case ZXClothesSizeMedium:
            string=@"medium size";
            break;
        case ZXClothesSizeLarge:
            string=@"small size";
            break;
        default:
            break;
    }
    NSLog(@"bought some clothes of %@",string);
}

@end
