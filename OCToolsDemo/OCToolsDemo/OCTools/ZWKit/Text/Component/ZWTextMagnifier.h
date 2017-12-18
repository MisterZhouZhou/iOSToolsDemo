//
//  ZWTextMagnifier.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/18.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<ZWKit/ZWKit.h>)
#import <ZWKit/ZWTextAttribute.h>
#else
#import "ZWTextAttribute.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// Magnifier type
typedef NS_ENUM(NSInteger, ZWTextMagnifierType) {
    ZWTextMagnifierTypeCaret,  ///< Circular magnifier
    ZWTextMagnifierTypeRanged, ///< Round rectangle magnifier
};

/**
 A magnifier view which can be displayed in `YYTextEffectWindow`.
 
 @discussion Use `magnifierWithType:` to create instance.
 Typically, you should not use this class directly.
 */
@interface ZWTextMagnifier : UIView

/// Create a mangifier with the specified type. @param type The magnifier type.
+ (id)magnifierWithType:(ZWTextMagnifierType)type;

@property (nonatomic, readonly) ZWTextMagnifierType type;  ///< Type of magnifier
@property (nonatomic, readonly) CGSize fitSize;            ///< The 'best' size for magnifier view.
@property (nonatomic, readonly) CGSize snapshotSize;       ///< The 'best' snapshot image size for magnifier.
@property (nullable, nonatomic, strong) UIImage *snapshot; ///< The image in magnifier (readwrite).

@property (nullable, nonatomic, weak) UIView *hostView;   ///< The coordinate based view.
@property (nonatomic) CGPoint hostCaptureCenter;          ///< The snapshot capture center in `hostView`.
@property (nonatomic) CGPoint hostPopoverCenter;          ///< The popover center in `hostView`.
@property (nonatomic) BOOL hostVerticalForm;              ///< The host view is vertical form.
@property (nonatomic) BOOL captureDisabled;               ///< A hint for `YYTextEffectWindow` to disable capture.
@property (nonatomic) BOOL captureFadeAnimation;          ///< Show fade animation when the snapshot image changed.
@end

NS_ASSUME_NONNULL_END
