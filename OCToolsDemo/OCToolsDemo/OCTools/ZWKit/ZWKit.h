//
//  ZWKit.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/29.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

// 动手敲一敲 YYKit 代码

#if __has_include("ZWKit.h") || __has_include(<ZWKit.h/ZWKit.h>)

//#warning xxxxx
FOUNDATION_EXPORT double ZWKitVersionNumber;
FOUNDATION_EXPORT const unsigned char ZWKitVersionString[];

#import "ZWKitMacro.h"
// Foundation
#import "NSObject+ZWAdd.h"
#import "NSObject+ZWAddForARC.h"
#import "NSObject+ZWAddForKVO.h"
#import "NSString+ZWAdd.h"
#import "NSData+ZWAdd.h"
#import "NSNumber+ZWAdd.h"
#import "NSArray+ZWAdd.h"
#import "NSDictionary+ZWAdd.h"
#import "NSDate+ZWAdd.h"
#import "NSNotificationCenter+ZWAdd.h"
#import "NSKeyedUnarchiver+ZWAdd.h"
#import "NSTimer+ZWAdd.h"
#import "NSBundle+ZWAdd.h"
#import "NSThread+ZWAdd.h"

// UIkit
#import "UIColor+ZWAdd.h"
#import "UIImage+ZWAdd.h"
#import "UIControl+ZWAdd.h"
#import "UIBarButtonItem+ZWAdd.h"
#import "UIGestureRecognizer+ZWAdd.h"
#import "UIView+ZWAdd.h"
#import "UIScrollView+ZWAdd.h"
#import "UITableView+ZWAdd.h"
#import "UITextField+ZWAdd.h"
#import "UIScreen+ZWAdd.h"
#import "UIDevice+ZWAdd.h"
#import "UIApplication+ZWAdd.h"
#import "UIFont+ZWAdd.h"
#import "UIBezierPath+ZWAdd.h"

// Quzrtz
#import "ZWCGUtilities.h"
#import "CALayer+ZWAdd.h"



// Text
#import "ZWLabel.h"

// Text string
#import "ZWTextAttribute.h"
#import "ZWTextArchiver.h"
#import "ZWTextParser.h"
#import "ZWTextUtilities.h"
#import "ZWTextRunDelegate.h"
#import "ZWTextRubyAnnotation.h"
#import "NSAttributedString+ZWText.h"
#import "NSParagraphStyle+ZWText.h"

// Text component
#import "ZWTextLayout.h"
#import "ZWTextLine.h"
#import "ZWTextInput.h"
#import "ZWTextDebugOption.h"


//Cache
#import "ZWCache.h"
#import "ZWMemoryCache.h"
#import "ZWDiskCache.h"

#endif
