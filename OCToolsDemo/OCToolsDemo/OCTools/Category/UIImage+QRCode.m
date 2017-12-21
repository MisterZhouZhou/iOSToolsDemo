//
//  UIImage+QRCode.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/5.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "UIImage+QRCode.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImage (QRCode)

/**
 *  从照片中直接识别二维码
 *  @param myQRCode    二维码包含的内容
 */
- (void)readQRCodeWithMyQRCode:(void(^)(NSString *qrString,NSError *error))myQRCode{
    UIImage * srcImage = self;
    if (!srcImage) {
        myQRCode(nil,[NSError errorWithDomain:@"未传入图片" code:0 userInfo:nil]);
        return;
    }
    // 开始识别
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    if (features.count) {
        CIQRCodeFeature *feature = [features firstObject];
        NSString *result = feature.messageString;
        myQRCode(result,nil);
    }
    else{
        myQRCode(nil,[NSError errorWithDomain:@"未能识别出二维码" code:0 userInfo:nil]);
        return;
    }
}

#pragma mark - 调整图片大小
+ (UIImage *)resizeImageWithoutInterpolation:(UIImage *)sourceImage size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    [sourceImage drawInRect:(CGRect){.size = size}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

#pragma mark - CIImage转换为UIImage
+ (UIImage *)imageWithCIImage:(CIImage *)aCIImage orientation: (UIImageOrientation)anOrientation
{
    if (!aCIImage) return nil;
    CGImageRef imageRef = [[CIContext contextWithOptions:nil] createCGImage:aCIImage fromRect:aCIImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:anOrientation];
    CFRelease(imageRef);
    return image;
}

+ (void)configWithColor:(UIColor *)color bgColor:(UIColor *)bgcolor andFilter:(CIFilter*)filter{
    if (color == nil) {
        color = [UIColor blackColor];
    }
    if (bgcolor == nil) {
        bgcolor = [UIColor whiteColor];
    }
    [filter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
    //背景颜色
    [filter setValue:[CIColor colorWithCGColor:bgcolor.CGColor] forKey:@"inputColor1"];
}

#pragma mark - 二维码生成
+ (UIImage *)qrImageWithString:(NSString *)string size:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor
{
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    if (!qrFilter){
        NSLog(@"Error: Could not load filter");
        return nil;
    }
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    CIFilter * colorQRFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorQRFilter setValue:qrFilter.outputImage forKey:@"inputImage"];
    //二维码颜色
    [self configWithColor:color bgColor:backGroundColor andFilter:colorQRFilter];
    // 输出二维码
    CIImage *outputImage = [colorQRFilter valueForKey:@"outputImage"];
    UIImage *smallImage = [self imageWithCIImage:outputImage orientation: UIImageOrientationUp];
    return [self resizeImageWithoutInterpolation:smallImage size:size];
}

#pragma mark - 条形码生成
+ (UIImage *)generateBarCode:(NSString *)code size:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor{
    // 生成条形码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    
    //设置条形码颜色和背景颜色
    CIFilter * colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setValue:filter.outputImage forKey:@"inputImage"];
    
    //条形码颜色
    [self configWithColor:color bgColor:backGroundColor andFilter:colorFilter];
    barcodeImage = [colorFilter outputImage];
    
    // 消除模糊
    CGFloat scaleX = size.width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = size.height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

#pragma mark - 保存gif到系统相册
- (void)saveGifToSysLibraryBlock:(void(^)(void))success failBlock:(void(^)(NSError *error))fail{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSDictionary *metadata = @{@"UTI":(__bridge NSString *)kUTTypeGIF};
    NSData *gifData = UIImagePNGRepresentation(self);
    [library writeImageDataToSavedPhotosAlbum:gifData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            // "保存图片失败"
            if(fail) fail(error);
        }else{
            //保存图片成功"
            if(success) success();
        }
    }] ;
#pragma clang diagnostic pop
}

@end
