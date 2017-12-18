//
//  ZWTextSelectionView.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/18.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<ZWKit/ZWKit.h>)
#import <ZWKit/ZWTextAttribute.h>
#import <ZWKit/ZWTextInput.h>
#else
#import "ZWTextAttribute.h"
#import "ZWTextInput.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 A single dot view. The frame should be foursquare.
 Change the background color for display.
 
 @discussion Typically, you should not use this class directly.
 */
@interface ZWSelectionGrabberDot : UIView
/// Dont't access this property. It was used by `YYTextEffectWindow`.
@property (nonatomic, strong) UIView *mirror;
@end


/**
 A grabber (stick with a dot).
 
 @discussion Typically, you should not use this class directly.
 */
@interface ZWSelectionGrabber : UIView

@property (nonatomic, readonly) ZWSelectionGrabberDot *dot; ///< the dot view
@property (nonatomic) ZWTextDirection dotDirection;         ///< don't support composite direction
@property (nullable, nonatomic, strong) UIColor *color;     ///< tint color, default is nil

@end


/**
 The selection view for text edit and select.
 
 @discussion Typically, you should not use this class directly.
 */
@interface ZWTextSelectionView : UIView

@property (nullable, nonatomic, weak) UIView *hostView; ///< the holder view
@property (nullable, nonatomic, strong) UIColor *color; ///< the tint color
@property (nonatomic, getter = isCaretBlinks) BOOL caretBlinks; ///< whether the caret is blinks
@property (nonatomic, getter = isCaretVisible) BOOL caretVisible; ///< whether the caret is visible
@property (nonatomic, getter = isVerticalForm) BOOL verticalForm; ///< weather the text view is vertical form

@property (nonatomic) CGRect caretRect; ///< caret rect (width==0 or height==0)
@property (nullable, nonatomic, copy) NSArray<ZWTextSelectionRect *> *selectionRects; ///< default is nil

@property (nonatomic, readonly) UIView *caretView;
@property (nonatomic, readonly) ZWSelectionGrabber *startGrabber;
@property (nonatomic, readonly) ZWSelectionGrabber *endGrabber;

- (BOOL)isGrabberContainsPoint:(CGPoint)point;
- (BOOL)isStartGrabberContainsPoint:(CGPoint)point;
- (BOOL)isEndGrabberContainsPoint:(CGPoint)point;
- (BOOL)isCaretContainsPoint:(CGPoint)point;
- (BOOL)isSelectionRectsContainsPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
