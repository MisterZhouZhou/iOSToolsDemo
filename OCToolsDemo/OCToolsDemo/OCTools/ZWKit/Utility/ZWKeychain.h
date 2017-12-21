//
//  ZWKeychain.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/20.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZWKeychainItem;

NS_ASSUME_NONNULL_BEGIN

/**
 A wrapper for system keychain API.
 
 Inspired by [SSKeychain](https://github.com/soffes/sskeychain) 😜
 */
@interface ZWKeychain : NSObject

#pragma mark - Convenience method for keychain
///=============================================================================
/// @name Convenience method for keychain
///=============================================================================

/**
 Returns the password for a given account and service, or `nil` if not found or
 an error occurs.
 
 @param serviceName The service for which to return the corresponding password.
 This value must not be nil.
 
 @param account The account for which to return the corresponding password.
 This value must not be nil.
 
 @param error   On input, a pointer to an error object. If an error occurs,
 this pointer is set to an actual error object containing the error information.
 You may specify nil for this parameter if you do not want the error information.
 See `YYKeychainErrorCode`.
 
 @return Password string, or nil when not found or error occurs.
 */
+ (nullable NSString *)getPasswordForService:(NSString *)serviceName
                                     account:(NSString *)account
                                       error:(NSError **)error;
+ (nullable NSString *)getPasswordForService:(NSString *)serviceName
                                     account:(NSString *)account;

/**
 Deletes a password from the Keychain.
 
 @param serviceName The service for which to return the corresponding password.
 This value must not be nil.
 
 @param account The account for which to return the corresponding password.
 This value must not be nil.
 
 @param error   On input, a pointer to an error object. If an error occurs,
 this pointer is set to an actual error object containing the error information.
 You may specify nil for this parameter if you do not want the error information.
 See `YYKeychainErrorCode`.
 
 @return Whether succeed.
 */
+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;
+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account;

/**
 Insert or update the password for a given account and service.
 
 @param password    The new password.
 
 @param serviceName The service for which to return the corresponding password.
 This value must not be nil.
 
 @param account The account for which to return the corresponding password.
 This value must not be nil.
 
 @param error   On input, a pointer to an error object. If an error occurs,
 this pointer is set to an actual error object containing the error information.
 You may specify nil for this parameter if you do not want the error information.
 See `YYKeychainErrorCode`.
 
 @return Whether succeed.
 */
+ (BOOL)setPassword:(NSString *)password
         forService:(NSString *)serviceName
            account:(NSString *)account
              error:(NSError **)error;
+ (BOOL)setPassword:(NSString *)password
         forService:(NSString *)serviceName
            account:(NSString *)account;


#pragma mark - Full query for keychain (SQL-like)
///=============================================================================
/// @name Full query for keychain (SQL-like)
///=============================================================================

/**
 Insert an item into keychain.
 
 @discussion The service,account,password is required. If there's item exist
 already, an error occurs and insert fail.
 
 @param item  The item to insert.
 
 @param error On input, a pointer to an error object. If an error occurs,
 this pointer is set to an actual error object containing the error information.
 You may specify nil for this parameter if you do not want the error information.
 See `YYKeychainErrorCode`.
 
 @return Whether succeed.
 */
+ (BOOL)insertItem:(ZWKeychainItem *)item error:(NSError **)error;
+ (BOOL)insertItem:(ZWKeychainItem *)item;

/**
 Update item in keychain.
 
 @discussion The service,account,password is required. If there's no item exist
 already, an error occurs and insert fail.
 
 @param item  The item to insert.
 
 @param error On input, a pointer to an error object. If an error occurs,
 this pointer is set to an actual error object containing the error information.
 You may specify nil for this parameter if you do not want the error information.
 See `YYKeychainErrorCode`.
 
 @return Whether succeed.
 */
+ (BOOL)updateItem:(ZWKeychainItem *)item error:(NSError **)error;
+ (BOOL)updateItem:(ZWKeychainItem *)item;

/**
 Delete items from keychain.
 
 @discussion The service,account,password is required. If there's item exist
 already, an error occurs and insert fail.
 
 @param item  The item to update.
 
 @param error On input, a pointer to an error object. If an error occurs,
 this pointer is set to an actual error object containing the error information.
 You may specify nil for this parameter if you do not want the error information.
 See `YYKeychainErrorCode`.
 
 @return Whether succeed.
 */
+ (BOOL)deleteItem:(ZWKeychainItem *)item error:(NSError **)error;
+ (BOOL)deleteItem:(ZWKeychainItem *)item;

/**
 Find an item from keychain.
 
 @discussion The service,account is optinal. It returns only one item if there
 exist multi.
 
 @param item  The item for query.
 
 @param error On input, a pointer to an error object. If an error occurs,
 this pointer is set to an actual error object containing the error information.
 You may specify nil for this parameter if you do not want the error information.
 See `YYKeychainErrorCode`.
 
 @return An item or nil.
 */
+ (nullable ZWKeychainItem *)selectOneItem:(ZWKeychainItem *)item error:(NSError **)error;
+ (nullable ZWKeychainItem *)selectOneItem:(ZWKeychainItem *)item;

/**
 Find all items matches the query.
 
 @discussion The service,account is optinal. It returns all item matches by the
 query.
 
 @param item  The item for query.
 
 @param error On input, a pointer to an error object. If an error occurs,
 this pointer is set to an actual error object containing the error information.
 You may specify nil for this parameter if you do not want the error information.
 See `YYKeychainErrorCode`.
 
 @return An array of YYKeychainItem.
 */
+ (nullable NSArray<ZWKeychainItem *> *)selectItems:(ZWKeychainItem *)item error:(NSError **)error;
+ (nullable NSArray<ZWKeychainItem *> *)selectItems:(ZWKeychainItem *)item;


@end


#pragma mark - Const

/**
 Error code in YYKeychain API.
 */
typedef NS_ENUM (NSUInteger, ZWKeychainErrorCode) {
    ZWKeychainErrorUnimplemented = 1, ///< Function or operation not implemented.
    ZWKeychainErrorIO, ///< I/O error (bummers)
    ZWKeychainErrorOpWr, ///< File already open with with write permission.
    ZWKeychainErrorParam, ///< One or more parameters passed to a function where not valid.
    ZWKeychainErrorAllocate, ///< Failed to allocate memory.
    ZWKeychainErrorUserCancelled, ///< User cancelled the operation.
    ZWKeychainErrorBadReq, ///< Bad parameter or invalid state for operation.
    ZWKeychainErrorInternalComponent, ///< Internal...
    ZWKeychainErrorNotAvailable, ///< No keychain is available. You may need to restart your computer.
    ZWKeychainErrorDuplicateItem, ///< The specified item already exists in the keychain.
    ZWKeychainErrorItemNotFound, ///< The specified item could not be found in the keychain.
    ZWKeychainErrorInteractionNotAllowed, ///< User interaction is not allowed.
    ZWKeychainErrorDecode, ///< Unable to decode the provided data.
    ZWKeychainErrorAuthFailed, ///< The user name or passphrase you entered is not.
};


/**
 When query to return the item's data, the error
 errSecInteractionNotAllowed will be returned if the item's data is not
 available until a device unlock occurs.
 */
typedef NS_ENUM (NSUInteger, ZWKeychainAccessible) {
    ZWKeychainAccessibleNone = 0, ///< no value
    
    /** Item data can only be accessed
     while the device is unlocked. This is recommended for items that only
     need be accesible while the application is in the foreground.  Items
     with this attribute will migrate to a new device when using encrypted
     backups. */
    ZWKeychainAccessibleWhenUnlocked,
    
    /** Item data can only be
     accessed once the device has been unlocked after a restart.  This is
     recommended for items that need to be accesible by background
     applications. Items with this attribute will migrate to a new device
     when using encrypted backups.*/
    ZWKeychainAccessibleAfterFirstUnlock,
    
    /** Item data can always be accessed
     regardless of the lock state of the device.  This is not recommended
     for anything except system use. Items with this attribute will migrate
     to a new device when using encrypted backups.*/
    ZWKeychainAccessibleAlways,
    
    /** Item data can
     only be accessed while the device is unlocked. This class is only
     available if a passcode is set on the device. This is recommended for
     items that only need to be accessible while the application is in the
     foreground. Items with this attribute will never migrate to a new
     device, so after a backup is restored to a new device, these items
     will be missing. No items can be stored in this class on devices
     without a passcode. Disabling the device passcode will cause all
     items in this class to be deleted.*/
    ZWKeychainAccessibleWhenPasscodeSetThisDeviceOnly,
    
    /** Item data can only
     be accessed while the device is unlocked. This is recommended for items
     that only need be accesible while the application is in the foreground.
     Items with this attribute will never migrate to a new device, so after
     a backup is restored to a new device, these items will be missing. */
    ZWKeychainAccessibleWhenUnlockedThisDeviceOnly,
    
    /** Item data can
     only be accessed once the device has been unlocked after a restart.
     This is recommended for items that need to be accessible by background
     applications. Items with this attribute will never migrate to a new
     device, so after a backup is restored to a new device these items will
     be missing.*/
    ZWKeychainAccessibleAfterFirstUnlockThisDeviceOnly,
    
    /** Item data can always
     be accessed regardless of the lock state of the device.  This option
     is not recommended for anything except system use. Items with this
     attribute will never migrate to a new device, so after a backup is
     restored to a new device, these items will be missing.*/
    ZWKeychainAccessibleAlwaysThisDeviceOnly,
};

/**
 Whether the item in question can be synchronized.
 */
typedef NS_ENUM (NSUInteger, ZWKeychainQuerySynchronizationMode) {
    
    /** Default, Don't care for synchronization  */
    ZWKeychainQuerySynchronizationModeAny = 0,
    
    /** Is not synchronized */
    ZWKeychainQuerySynchronizationModeNo,
    
    /** To add a new item which can be synced to other devices, or to obtain
     synchronized results from a query*/
    ZWKeychainQuerySynchronizationModeYes,
} NS_AVAILABLE_IOS (7_0);


#pragma mark - Item

/**
 Wrapper for keychain item/query.
 */
@interface ZWKeychainItem : NSObject <NSCopying>

@property (nullable, nonatomic, copy) NSString *service; ///< kSecAttrService
@property (nullable, nonatomic, copy) NSString *account; ///< kSecAttrAccount
@property (nullable, nonatomic, copy) NSData *passwordData; ///< kSecValueData
@property (nullable, nonatomic, copy) NSString *password; ///< shortcut for `passwordData`
@property (nullable, nonatomic, copy) id <NSCoding> passwordObject; ///< shortcut for `passwordData`

@property (nullable, nonatomic, copy) NSString *label; ///< kSecAttrLabel
@property (nullable, nonatomic, copy) NSNumber *type; ///< kSecAttrType (FourCC)
@property (nullable, nonatomic, copy) NSNumber *creater; ///< kSecAttrCreator (FourCC)
@property (nullable, nonatomic, copy) NSString *comment; ///< kSecAttrComment
@property (nullable, nonatomic, copy) NSString *descr; ///< kSecAttrDescription
@property (nullable, nonatomic, readonly, strong) NSDate *modificationDate; ///< kSecAttrModificationDate
@property (nullable, nonatomic, readonly, strong) NSDate *creationDate; ///< kSecAttrCreationDate
@property (nullable, nonatomic, copy) NSString *accessGroup; ///< kSecAttrAccessGroup

@property (nonatomic) ZWKeychainAccessible accessible; ///< kSecAttrAccessible
@property (nonatomic) ZWKeychainQuerySynchronizationMode synchronizable NS_AVAILABLE_IOS(7_0); ///< kSecAttrSynchronizable

@end

NS_ASSUME_NONNULL_END
