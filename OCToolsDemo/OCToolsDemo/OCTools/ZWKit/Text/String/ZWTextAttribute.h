//
//  ZWTextAttribute.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/12.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum Define

/// The attribute type
typedef NS_OPTIONS(NSInteger, ZWTextAttributeType) {
    ZWTextAttributeTypeNone     = 0,
    ZWTextAttributeTypeUIKit    = 1 << 0, ///< UIKit attributes, such as UILabel/UITextField/drawInRect.
    ZWTextAttributeTypeCoreText = 1 << 1, ///< CoreText attributes, used by CoreText.
    ZWTextAttributeTypeYYText   = 1 << 2, ///< YYText attributes, used by YYText.
};


/// Get the attribute type from an attribute name. 导出TextAttributeType获取方法
extern ZWTextAttributeType ZWTextAttributeGetType(NSString *attributeName);

/**
 Line style in YYText (similar to NSUnderlineStyle).
 */
typedef NS_OPTIONS (NSInteger, ZWTextLineStyle) {
    // basic style (bitmask:0xFF)
    ZWTextLineStyleNone       = 0x00, ///< (        ) Do not draw a line (Default).
    ZWTextLineStyleSingle     = 0x01, ///< (──────) Draw a single line.
    ZWTextLineStyleThick      = 0x02, ///< (━━━━━━━) Draw a thick line.
    ZWTextLineStyleDouble     = 0x09, ///< (══════) Draw a double line.
    
    // style pattern (bitmask:0xF00)
    ZWTextLineStylePatternSolid      = 0x000, ///< (────────) Draw a solid line (Default).
    ZWTextLineStylePatternDot        = 0x100, ///< (‑ ‑ ‑ ‑ ‑ ‑) Draw a line of dots.
    ZWTextLineStylePatternDash       = 0x200, ///< (— — — —) Draw a line of dashes.
    ZWTextLineStylePatternDashDot    = 0x300, ///< (— ‑ — ‑ — ‑) Draw a line of alternating dashes and dots.
    ZWTextLineStylePatternDashDotDot = 0x400, ///< (— ‑ ‑ — ‑ ‑) Draw a line of alternating dashes and two dots.
    ZWTextLineStylePatternCircleDot  = 0x900, ///< (••••••••••••) Draw a line of small circle dots.
};

/**
 Text vertical alignment.
 */
typedef NS_ENUM(NSInteger, ZWTextVerticalAlignment) {
    ZWTextVerticalAlignmentTop =    0, ///< Top alignment.
    ZWTextVerticalAlignmentCenter = 1, ///< Center alignment.
    ZWTextVerticalAlignmentBottom = 2, ///< Bottom alignment.
};

/**
 The direction define in YYText.
 */
typedef NS_OPTIONS(NSUInteger, ZWTextDirection) {
    ZWTextDirectionNone   = 0,
    ZWTextDirectionTop    = 1 << 0,
    ZWTextDirectionRight  = 1 << 1,
    ZWTextDirectionBottom = 1 << 2,
    ZWTextDirectionLeft   = 1 << 3,
};


/**
 The trunction type, tells the truncation engine which type of truncation is being requested.
 */
typedef NS_ENUM (NSUInteger, ZWTextTruncationType) {
    /// No truncate.
    ZWTextTruncationTypeNone   = 0,
    
    /// Truncate at the beginning of the line, leaving the end portion visible.
    ZWTextTruncationTypeStart  = 1,
    
    /// Truncate at the end of the line, leaving the start portion visible.
    ZWTextTruncationTypeEnd    = 2,
    
    /// Truncate in the middle of the line, leaving both the start and the end portions visible.
    ZWTextTruncationTypeMiddle = 3,
};


#pragma mark - Attribute Name Defined in ZWText

/// The value of this attribute is a `YYTextBackedString` object.
/// Use this attribute to store the original plain text if it is replaced by something else (such as attachment).
UIKIT_EXTERN NSString *const ZWTextBackedStringAttributeName;

/// The value of this attribute is a `YYTextBinding` object.
/// Use this attribute to bind a range of text together, as if it was a single charactor.
UIKIT_EXTERN NSString *const ZWTextBindingAttributeName;

/// The value of this attribute is a `YYTextShadow` object.
/// Use this attribute to add shadow to a range of text.
/// Shadow will be drawn below text glyphs. Use YYTextShadow.subShadow to add multi-shadow.
UIKIT_EXTERN NSString *const ZWTextShadowAttributeName;

/// The value of this attribute is a `YYTextShadow` object.
/// Use this attribute to add inner shadow to a range of text.
/// Inner shadow will be drawn above text glyphs. Use YYTextShadow.subShadow to add multi-shadow.
UIKIT_EXTERN NSString *const ZWTextInnerShadowAttributeName;

/// The value of this attribute is a `YYTextDecoration` object.
/// Use this attribute to add underline to a range of text.
/// The underline will be drawn below text glyphs.
UIKIT_EXTERN NSString *const ZWTextUnderlineAttributeName;

/// The value of this attribute is a `YYTextDecoration` object.
/// Use this attribute to add strikethrough (delete line) to a range of text.
/// The strikethrough will be drawn above text glyphs.
UIKIT_EXTERN NSString *const ZWTextStrikethroughAttributeName;

/// The value of this attribute is a `YYTextBorder` object.
/// Use this attribute to add cover border or cover color to a range of text.
/// The border will be drawn above the text glyphs.
UIKIT_EXTERN NSString *const ZWTextBorderAttributeName;

/// The value of this attribute is a `YYTextBorder` object.
/// Use this attribute to add background border or background color to a range of text.
/// The border will be drawn below the text glyphs.
UIKIT_EXTERN NSString *const ZWTextBackgroundBorderAttributeName;

/// The value of this attribute is a `YYTextBorder` object.
/// Use this attribute to add a code block border to one or more line of text.
/// The border will be drawn below the text glyphs.
UIKIT_EXTERN NSString *const ZWTextBlockBorderAttributeName;

/// The value of this attribute is a `YYTextAttachment` object.
/// Use this attribute to add attachment to text.
/// It should be used in conjunction with a CTRunDelegate.
UIKIT_EXTERN NSString *const ZWTextAttachmentAttributeName;

/// The value of this attribute is a `YYTextHighlight` object.
/// Use this attribute to add a touchable highlight state to a range of text.
UIKIT_EXTERN NSString *const ZWTextHighlightAttributeName;

/// The value of this attribute is a `NSValue` object stores CGAffineTransform.
/// Use this attribute to add transform to each glyph in a range of text.
UIKIT_EXTERN NSString *const ZWTextGlyphTransformAttributeName;


#pragma mark - String Token Define

UIKIT_EXTERN NSString *const ZWTextAttachmentToken; ///< Object replacement character (U+FFFC), used for text attachment.
UIKIT_EXTERN NSString *const ZWTextTruncationToken; ///< Horizontal ellipsis (U+2026), used for text truncation  "…".


#pragma mark - Attribute Value Define

/**
 The tap/long press action callback defined in YYText.
 
 @param containerView The text container view (such as YYLabel/YYTextView).
 @param text          The whole text.
 @param range         The text range in `text` (if no range, the range.location is NSNotFound).
 @param rect          The text frame in `containerView` (if no data, the rect is CGRectNull).
 */
typedef void(^ZWTextAction)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect);



/**
 YYTextBackedString objects are used by the NSAttributedString class cluster
 as the values for text backed string attributes (stored in the attributed
 string under the key named YYTextBackedStringAttributeName).
 
 It may used for copy/paste plain text from attributed string.
 Example: If :) is replace by a custom emoji (such as😊), the backed string can be set to @":)".
 */
@interface ZWTextBackedString : NSObject <NSCoding, NSCopying>
+ (instancetype)stringWithString:(nullable NSString *)string;
@property (nullable, nonatomic, copy) NSString *string; ///< backed string
@end




/**
 YYTextBinding objects are used by the NSAttributedString class cluster
 as the values for shadow attributes (stored in the attributed string under
 the key named YYTextBindingAttributeName).
 
 Add this to a range of text will make the specified characters 'binding together'.
 YYTextView will treat the range of text as a single character during text
 selection and edit.
 */
@interface ZWTextBinding : NSObject <NSCoding, NSCopying>
+ (instancetype)bindingWithDeleteConfirm:(BOOL)deleteConfirm;
@property (nonatomic) BOOL deleteConfirm; ///< confirm the range when delete in YYTextView
@end




/**
 YYTextShadow objects are used by the NSAttributedString class cluster
 as the values for shadow attributes (stored in the attributed string under
 the key named YYTextShadowAttributeName or YYTextInnerShadowAttributeName).
 
 It's similar to `NSShadow`, but offers more options.
 */
@interface ZWTextShadow : NSObject <NSCoding, NSCopying>
+ (instancetype)shadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

@property (nullable, nonatomic, strong) UIColor *color; ///< shadow color
@property (nonatomic) CGSize offset;                    ///< shadow offset
@property (nonatomic) CGFloat radius;                   ///< shadow blur radius
@property (nonatomic) CGBlendMode blendMode;            ///< shadow blend mode
@property (nullable, nonatomic, strong) ZWTextShadow *subShadow;  ///< a sub shadow which will be added above the parent shadow

+ (instancetype)shadowWithNSShadow:(NSShadow *)nsShadow; ///< convert NSShadow to YYTextShadow
- (NSShadow *)nsShadow; ///< convert YYTextShadow to NSShadow
@end




/**
 YYTextDecorationLine objects are used by the NSAttributedString class cluster
 as the values for decoration line attributes (stored in the attributed string under
 the key named YYTextUnderlineAttributeName or YYTextStrikethroughAttributeName).
 
 When it's used as underline, the line is drawn below text glyphs;
 when it's used as strikethrough, the line is drawn above text glyphs.
 */
@interface ZWTextDecoration : NSObject <NSCoding, NSCopying>
+ (instancetype)decorationWithStyle:(ZWTextLineStyle)style;
+ (instancetype)decorationWithStyle:(ZWTextLineStyle)style width:(nullable NSNumber *)width color:(nullable UIColor *)color;
@property (nonatomic) ZWTextLineStyle style;                   ///< line style
@property (nullable, nonatomic, strong) NSNumber *width;       ///< line width (nil means automatic width)
@property (nullable, nonatomic, strong) UIColor *color;        ///< line color (nil means automatic color)
@property (nullable, nonatomic, strong) ZWTextShadow *shadow;  ///< line shadow
@end


/**
 YYTextBorder objects are used by the NSAttributedString class cluster
 as the values for border attributes (stored in the attributed string under
 the key named YYTextBorderAttributeName or YYTextBackgroundBorderAttributeName).
 
 It can be used to draw a border around a range of text, or draw a background
 to a range of text.
 
 Example:
 ╭──────╮
 │ Text │
 ╰──────╯
 */
@interface ZWTextBorder : NSObject <NSCoding, NSCopying>
+ (instancetype)borderWithLineStyle:(ZWTextLineStyle)lineStyle lineWidth:(CGFloat)width strokeColor:(nullable UIColor *)color;
+ (instancetype)borderWithFillColor:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius;
@property (nonatomic) ZWTextLineStyle lineStyle;              ///< border line style
@property (nonatomic) CGFloat strokeWidth;                    ///< border line width
@property (nullable, nonatomic, strong) UIColor *strokeColor; ///< border line color
@property (nonatomic) CGLineJoin lineJoin;                    ///< border line join
@property (nonatomic) UIEdgeInsets insets;                    ///< border insets for text bounds
@property (nonatomic) CGFloat cornerRadius;                   ///< border corder radius
@property (nullable, nonatomic, strong) ZWTextShadow *shadow; ///< border shadow
@property (nullable, nonatomic, strong) UIColor *fillColor;   ///< inner fill color
@end




/**
 YYTextAttachment objects are used by the NSAttributedString class cluster
 as the values for attachment attributes (stored in the attributed string under
 the key named YYTextAttachmentAttributeName).
 
 When display an attributed string which contains `YYTextAttachment` object,
 the content will be placed in text metric. If the content is `UIImage`,
 then it will be drawn to CGContext; if the content is `UIView` or `CALayer`,
 then it will be added to the text container's view or layer.
 */
@interface ZWTextAttachment : NSObject<NSCoding, NSCopying>
+ (instancetype)attachmentWithContent:(nullable id)content;
@property (nullable, nonatomic, strong) id content;             ///< Supported type: UIImage, UIView, CALayer
@property (nonatomic) UIViewContentMode contentMode;            ///< Content display mode.
@property (nonatomic) UIEdgeInsets contentInsets;               ///< The insets when drawing content.
@property (nullable, nonatomic, strong) NSDictionary *userInfo; ///< The user information dictionary.
@end






/**
 YYTextHighlight objects are used by the NSAttributedString class cluster
 as the values for touchable highlight attributes (stored in the attributed string
 under the key named YYTextHighlightAttributeName).
 
 When display an attributed string in `YYLabel` or `YYTextView`, the range of
 highlight text can be toucheds down by users. If a range of text is turned into
 highlighted state, the `attributes` in `YYTextHighlight` will be used to modify
 (set or remove) the original attributes in the range for display.
 */
@interface ZWTextHighlight : NSObject <NSCoding, NSCopying>

/**
 Attributes that you can apply to text in an attributed string when highlight.
 Key:   Same as CoreText/YYText Attribute Name.
 Value: Modify attribute value when highlight (NSNull for remove attribute).
 */
@property (nullable, nonatomic, copy) NSDictionary<NSString *, id> *attributes;

/**
 Creates a highlight object with specified attributes.
 
 @param attributes The attributes which will replace original attributes when highlight,
 If the value is NSNull, it will removed when highlight.
 */
+ (instancetype)highlightWithAttributes:(nullable NSDictionary<NSString *, id> *)attributes;

/**
 Convenience methods to create a default highlight with the specifeid background color.
 
 @param color The background border color.
 */
+ (instancetype)highlightWithBackgroundColor:(nullable UIColor *)color;

// Convenience methods below to set the `attributes`.
- (void)setFont:(nullable UIFont *)font;
- (void)setColor:(nullable UIColor *)color;
- (void)setStrokeWidth:(nullable NSNumber *)width;
- (void)setStrokeColor:(nullable UIColor *)color;
- (void)setShadow:(nullable ZWTextShadow *)shadow;
- (void)setInnerShadow:(nullable ZWTextShadow *)shadow;
- (void)setUnderline:(nullable ZWTextDecoration *)underline;
- (void)setStrikethrough:(nullable ZWTextDecoration *)strikethrough;
- (void)setBackgroundBorder:(nullable ZWTextBorder *)border;
- (void)setBorder:(nullable ZWTextBorder *)border;
- (void)setAttachment:(nullable ZWTextAttachment *)attachment;

/**
 The user information dictionary, default is nil.
 */
@property (nullable, nonatomic, copy) NSDictionary *userInfo;

/**
 Tap action when user tap the highlight, default is nil.
 If the value is nil, YYTextView or YYLabel will ask it's delegate to handle the tap action.
 */
@property (nullable, nonatomic, copy) ZWTextAction tapAction;

/**
 Long press action when user long press the highlight, default is nil.
 If the value is nil, YYTextView or YYLabel will ask it's delegate to handle the long press action.
 */
@property (nullable, nonatomic, copy) ZWTextAction longPressAction;

@end

NS_ASSUME_NONNULL_END
