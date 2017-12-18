//
//  ZWTextEffectWindow.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/18.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<ZWKit/ZWKit.h>)
#import <ZWKit/ZWTextMagnifier.h>
#import <ZWKit/ZWTextSelectionView.h>
#else
#import "ZWTextMagnifier.h"
#import "ZWTextSelectionView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 A window to display magnifier and extra contents for text view.
 
 @discussion Use `sharedWindow` to get the instance, don't create your own instance.
 Typically, you should not use this class directly.
 */
@interface ZWTextEffectWindow : UIWindow

/// Returns the shared instance (returns nil in App Extension).
+ (nullable instancetype)sharedWindow;

/// Show the magnifier in this window with a 'popup' animation. @param mag A magnifier.
- (void)showMagnifier:(ZWTextMagnifier *)mag;
/// Update the magnifier content and position. @param mag A magnifier.
- (void)moveMagnifier:(ZWTextMagnifier *)mag;
/// Remove the magnifier from this window with a 'shrink' animation. @param mag A magnifier.
- (void)hideMagnifier:(ZWTextMagnifier *)mag;


/// Show the selection dot in this window if the dot is clipped by the selection view.
/// @param selection A selection view.
- (void)showSelectionDot:(ZWTextSelectionView *)selection;
/// Remove the selection dot from this window.
/// @param selection A selection view.
- (void)hideSelectionDot:(ZWTextSelectionView *)selection;

@end

NS_ASSUME_NONNULL_END
