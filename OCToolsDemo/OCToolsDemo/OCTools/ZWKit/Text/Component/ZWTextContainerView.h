//
//  ZWTextContainerView.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/18.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<ZWKit/ZWKit.h>)
#import <ZWKit/ZWTextLayout.h>
#else
#import "ZWTextLayout.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 A simple view to diaplay `YYTextLayout`.
 
 @discussion This view can become first responder. If this view is first responder,
 all the action (such as UIMenu's action) would forward to the `hostView` property.
 Typically, you should not use this class directly.
 
 @warning All the methods in this class should be called on main thread.
 */
@interface ZWTextContainerView : UIView

/// First responder's aciton will forward to this view.
@property (nullable, nonatomic, weak) UIView *hostView;

/// Debug option for layout debug. Set this property will let the view redraw it's contents.
@property (nullable, nonatomic, copy) ZWTextDebugOption *debugOption;

/// Text vertical alignment.
@property (nonatomic) ZWTextVerticalAlignment textVerticalAlignment;

/// Text layout. Set this property will let the view redraw it's contents.
@property (nullable, nonatomic, strong) ZWTextLayout *layout;

/// The contents fade animation duration when the layout's contents changed. Default is 0 (no animation).
@property (nonatomic) NSTimeInterval contentsFadeDuration;

/// Convenience method to set `layout` and `contentsFadeDuration`.
/// @param layout  Same as `layout` property.
/// @param fadeDuration  Same as `contentsFadeDuration` property.
- (void)setLayout:(nullable ZWTextLayout *)layout withFadeDuration:(NSTimeInterval)fadeDuration;


@end

NS_ASSUME_NONNULL_END
