//
//  ZWImage.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/18.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<ZWKit/ZWKit.h>)
#import <ZWKit/ZWAnimatedImageView.h>
#import <ZWKit/ZWImageCoder.h>
#else
#import "ZWAnimatedImageView.h"
#import "ZWImageCoder.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 A YYImage object is a high-level way to display animated image data.
 
 @discussion It is a fully compatible `UIImage` subclass. It extends the UIImage
 to support animated WebP, APNG and GIF format image data decoding. It also
 support NSCoding protocol to archive and unarchive multi-frame image data.
 
 If the image is created from multi-frame image data, and you want to play the
 animation, try replace UIImageView with `YYAnimatedImageView`.
 
 Sample Code:
 
 // animation@3x.webp
 YYImage *image = [YYImage imageNamed:@"animation.webp"];
 YYAnimatedImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
 [view addSubView:imageView];
 
 */
@interface ZWImage : UIImage<ZWAnimatedImage>

+ (nullable ZWImage *)imageNamed:(NSString *)name; // no cache!
+ (nullable ZWImage *)imageWithContentsOfFile:(NSString *)path;
+ (nullable ZWImage *)imageWithData:(NSData *)data;
+ (nullable ZWImage *)imageWithData:(NSData *)data scale:(CGFloat)scale;

/**
 If the image is created from data or file, then the value indicates the data type.
 */
@property (nonatomic, readonly) ZWImageType animatedImageType;

/**
 If the image is created from animated image data (multi-frame GIF/APNG/WebP),
 this property stores the original image data.
 */
@property (nullable, nonatomic, readonly) NSData *animatedImageData;

/**
 The total memory usage (in bytes) if all frame images was loaded into memory.
 The value is 0 if the image is not created from a multi-frame image data.
 */
@property (nonatomic, readonly) NSUInteger animatedImageMemorySize;

/**
 Preload all frame image to memory.
 
 @discussion Set this property to `YES` will block the calling thread to decode
 all animation frame image to memory, set to `NO` will release the preloaded frames.
 If the image is shared by lots of image views (such as emoticon), preload all
 frames will reduce the CPU cost.
 
 See `animatedImageMemorySize` for memory cost.
 */
@property (nonatomic) BOOL preloadAllAnimatedImageFrames;

@end

NS_ASSUME_NONNULL_END
