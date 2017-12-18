//
//  NSParagraphStyle+ZWText.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/14.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `NSParagraphStyle` to work with CoreText.
 */
@interface NSParagraphStyle (ZWText)

/**
 Creates a new NSParagraphStyle object from the CoreText Style.
 
 @param CTStyle CoreText Paragraph Style.
 
 @return a new NSParagraphStyle
 */
+ (nullable NSParagraphStyle *)styleWithCTStyle:(CTParagraphStyleRef)CTStyle;

/**
 Creates and returns a CoreText Paragraph Style. (need call CFRelease() after used)
 */
- (nullable CTParagraphStyleRef)CTStyle CF_RETURNS_RETAINED;

@end

NS_ASSUME_NONNULL_END

