//
//  ZWTextLine.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/14.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#if __has_include(<ZWKit/ZWKit.h>)
#import <ZWKit/ZWTextAttribute.h>
#else
#import "ZWTextAttribute.h"
#endif


@class ZWTextRunGlyphRange;

NS_ASSUME_NONNULL_BEGIN

/**
 A text line object wrapped `CTLineRef`, see `YYTextLayout` for more.
 */
@interface ZWTextLine : NSObject

+ (instancetype)lineWithCTLine:(CTLineRef)CTLine position:(CGPoint)position vertical:(BOOL)isVertical;

@property (nonatomic) NSUInteger index;     ///< line index
@property (nonatomic) NSUInteger row;       ///< line row
@property (nullable, nonatomic, strong) NSArray<NSArray<ZWTextRunGlyphRange *> *> *verticalRotateRange; ///< Run rotate range

@property (nonatomic, readonly) CTLineRef CTLine;   ///< CoreText line
@property (nonatomic, readonly) NSRange range;      ///< string range
@property (nonatomic, readonly) BOOL vertical;      ///< vertical form

@property (nonatomic, readonly) CGRect bounds;      ///< bounds (ascent + descent)
@property (nonatomic, readonly) CGSize size;        ///< bounds.size
@property (nonatomic, readonly) CGFloat width;      ///< bounds.size.width
@property (nonatomic, readonly) CGFloat height;     ///< bounds.size.height
@property (nonatomic, readonly) CGFloat top;        ///< bounds.origin.y
@property (nonatomic, readonly) CGFloat bottom;     ///< bounds.origin.y + bounds.size.height
@property (nonatomic, readonly) CGFloat left;       ///< bounds.origin.x
@property (nonatomic, readonly) CGFloat right;      ///< bounds.origin.x + bounds.size.width

@property (nonatomic)   CGPoint position;   ///< baseline position
@property (nonatomic, readonly) CGFloat ascent;     ///< line ascent
@property (nonatomic, readonly) CGFloat descent;    ///< line descent
@property (nonatomic, readonly) CGFloat leading;    ///< line leading
@property (nonatomic, readonly) CGFloat lineWidth;  ///< line width
@property (nonatomic, readonly) CGFloat trailingWhitespaceWidth;

@property (nullable, nonatomic, readonly) NSArray<ZWTextAttachment *> *attachments; ///< YYTextAttachment
@property (nullable, nonatomic, readonly) NSArray<NSValue *> *attachmentRanges;     ///< NSRange(NSValue)
@property (nullable, nonatomic, readonly) NSArray<NSValue *> *attachmentRects;      ///< CGRect(NSValue)

@end

typedef NS_ENUM(NSUInteger, ZWTextRunGlyphDrawMode) {
    /// No rotate.
    ZWTextRunGlyphDrawModeHorizontal = 0,
    
    /// Rotate vertical for single glyph.
    ZWTextRunGlyphDrawModeVerticalRotate = 1,
    
    /// Rotate vertical for single glyph, and move the glyph to a better position,
    /// such as fullwidth punctuation.
    ZWTextRunGlyphDrawModeVerticalRotateMove = 2,
};

/**
 A range in CTRun, used for vertical form.
 */
@interface ZWTextRunGlyphRange : NSObject
@property (nonatomic) NSRange glyphRangeInRun;
@property (nonatomic) ZWTextRunGlyphDrawMode drawMode;
+ (instancetype)rangeWithRange:(NSRange)range drawMode:(ZWTextRunGlyphDrawMode)mode;

@end

NS_ASSUME_NONNULL_END
