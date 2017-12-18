//
//  ZWTextArchiver.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/12.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A subclass of `NSKeyedArchiver` which implement `NSKeyedArchiverDelegate` protocol.
 
 The archiver can encode the object which contains
 CGColor/CGImage/CTRunDelegateRef/.. (such as NSAttributedString).
 */
@interface ZWTextArchiver : NSKeyedArchiver <NSKeyedArchiverDelegate>
@end

/**
 A subclass of `NSKeyedUnarchiver` which implement `NSKeyedUnarchiverDelegate`
 protocol. The unarchiver can decode the data which is encoded by
 `YYTextArchiver` or `NSKeyedArchiver`.
 */
@interface ZWTextUnarchiver : NSKeyedUnarchiver <NSKeyedUnarchiverDelegate>
@end

NS_ASSUME_NONNULL_END
