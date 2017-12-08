//
//  UITextField+ZWAdd.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/8.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "UITextField+ZWAdd.h"
#import "ZWKitMacro.h"

ZWSYNTH_DUMMY_CLASS(UITextField_ZWAdd)


@implementation UITextField (ZWAdd)

- (void)selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
