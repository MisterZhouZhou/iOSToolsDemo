//
//  ZWGestureRecognizer.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/20.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// State of the gesture
typedef NS_ENUM(NSUInteger, ZWGestureRecognizerState) {
    ZWGestureRecognizerStateBegan, ///< gesture start
    ZWGestureRecognizerStateMoved, ///< gesture moved
    ZWGestureRecognizerStateEnded, ///< gesture end
    ZWGestureRecognizerStateCancelled, ///< gesture cancel
};

/**
 A simple UIGestureRecognizer subclass for receive touch events.
 */
@interface ZWGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) CGPoint startPoint; ///< start point
@property (nonatomic, readonly) CGPoint lastPoint; ///< last move point.
@property (nonatomic, readonly) CGPoint currentPoint; ///< current move point.

/// The action block invoked by every gesture event.
@property (nullable, nonatomic, copy) void (^action)(ZWGestureRecognizer *gesture, ZWGestureRecognizerState state);

/// Cancel the gesture for current touch.
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
