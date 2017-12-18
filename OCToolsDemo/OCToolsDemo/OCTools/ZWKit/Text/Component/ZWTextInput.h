//
//  ZWTextInput.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/14.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Text position affinity. For example, the offset appears after the last
 character on a line is backward affinity, before the first character on
 the following line is forward affinity.
 */
typedef NS_ENUM(NSInteger, ZWTextAffinity) {
    ZWTextAffinityForward  = 0, ///< offset appears before the character
    ZWTextAffinityBackward = 1, ///< offset appears after the character
};


/**
 A YYTextPosition object represents a position in a text container; in other words,
 it is an index into the backing string in a text-displaying view.
 
 YYTextPosition has the same API as Apple's implementation in UITextView/UITextField,
 so you can alse use it to interact with UITextView/UITextField.
 */
@interface ZWTextPosition : UITextPosition <NSCopying>

@property (nonatomic, readonly) NSInteger offset;
@property (nonatomic, readonly) ZWTextAffinity affinity;

+ (instancetype)positionWithOffset:(NSInteger)offset;
+ (instancetype)positionWithOffset:(NSInteger)offset affinity:(ZWTextAffinity) affinity;

- (NSComparisonResult)compare:(id)otherPosition;

@end


/**
 A YYTextRange object represents a range of characters in a text container; in other words,
 it identifies a starting index and an ending index in string backing a text-displaying view.
 
 YYTextRange has the same API as Apple's implementation in UITextView/UITextField,
 so you can alse use it to interact with UITextView/UITextField.
 */
@interface ZWTextRange : UITextRange <NSCopying>

@property (nonatomic, readonly) ZWTextPosition *start;
@property (nonatomic, readonly) ZWTextPosition *end;
@property (nonatomic, readonly, getter=isEmpty) BOOL empty;

+ (instancetype)rangeWithRange:(NSRange)range;
+ (instancetype)rangeWithRange:(NSRange)range affinity:(ZWTextAffinity) affinity;
+ (instancetype)rangeWithStart:(ZWTextPosition *)start end:(ZWTextPosition *)end;
+ (instancetype)defaultRange; ///< <{0,0} Forward>

- (NSRange)asRange;

@end


/**
 A YYTextSelectionRect object encapsulates information about a selected range of
 text in a text-displaying view.
 
 YYTextSelectionRect has the same API as Apple's implementation in UITextView/UITextField,
 so you can alse use it to interact with UITextView/UITextField.
 */
@interface ZWTextSelectionRect : UITextSelectionRect <NSCopying>

@property (nonatomic, readwrite) CGRect rect;
@property (nonatomic, readwrite) UITextWritingDirection writingDirection;
@property (nonatomic, readwrite) BOOL containsStart;
@property (nonatomic, readwrite) BOOL containsEnd;
@property (nonatomic, readwrite) BOOL isVertical;

@end

NS_ASSUME_NONNULL_END

