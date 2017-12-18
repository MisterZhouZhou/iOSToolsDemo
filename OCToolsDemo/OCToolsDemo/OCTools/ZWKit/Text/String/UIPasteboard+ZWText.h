//
//  UIPasteboard+ZWText.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/18.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Extend UIPasteboard to support image and attributed string.
 */
@interface UIPasteboard (ZWText)

@property (nullable, nonatomic, copy) NSData *PNGData;    ///< PNG file data
@property (nullable, nonatomic, copy) NSData *JPEGData;   ///< JPEG file data
@property (nullable, nonatomic, copy) NSData *GIFData;    ///< GIF file data
@property (nullable, nonatomic, copy) NSData *WEBPData;   ///< WebP file data
@property (nullable, nonatomic, copy) NSData *imageData;  ///< image file data

/// Attributed string,
/// Set this attributed will also set the string property which is copy from the attributed string.
/// If the attributed string contains one or more image, it will also set the `images` property.
@property (nullable, nonatomic, copy) NSAttributedString *attributedString;

@end


/// The name identifying the attributed string in pasteboard.
UIKIT_EXTERN NSString *const ZWPasteboardTypeAttributedString;

/// The UTI Type identifying WebP data in pasteboard.
UIKIT_EXTERN NSString *const ZWUTTypeWEBP;

NS_ASSUME_NONNULL_END
