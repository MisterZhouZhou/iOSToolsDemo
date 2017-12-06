//
//  ZWCGUtilities.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/6.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#if __has_include(<ZWKit/ZWKit.h>)
#import "<ZWKit/ZWKitMacro.h>
#else
#import "ZWKitMacro.h"
#endif

// C extern
ZW_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN


/**
 Returns a rectangle to fit the `rect` with specified content mode.
 
 @param rect The constrant rect
 @param size The content size
 @param mode The content mode
 @return A rectangle for the given content mode.
 @discussion UIViewContentModeRedraw is same as UIViewContentModeScaleToFill.
 */
CGRect ZWCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);

/// Convert degrees to radians.
static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

NS_ASSUME_NONNULL_END
ZW_EXTERN_C_END
