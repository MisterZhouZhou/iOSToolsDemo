//
//  ZWKeychain.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/20.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ZWKeychain.h"
#import "UIDevice+ZWAdd.h"
#import "ZWKitMacro.h"
#import <Security/Security.h>

static ZWKeychainErrorCode ZWKeychainErrorCodeFromOSStatus(OSStatus status) {
    switch (status) {
        case errSecUnimplemented: return ZWKeychainErrorUnimplemented;
        case errSecIO: return ZWKeychainErrorIO;
        case errSecOpWr: return ZWKeychainErrorOpWr;
        case errSecParam: return ZWKeychainErrorParam;
        case errSecAllocate: return ZWKeychainErrorAllocate;
        case errSecUserCanceled: return ZWKeychainErrorUserCancelled;
        case errSecBadReq: return ZWKeychainErrorBadReq;
        case errSecInternalComponent: return ZWKeychainErrorInternalComponent;
        case errSecNotAvailable: return ZWKeychainErrorNotAvailable;
        case errSecDuplicateItem: return ZWKeychainErrorDuplicateItem;
        case errSecItemNotFound: return ZWKeychainErrorItemNotFound;
        case errSecInteractionNotAllowed: return ZWKeychainErrorInteractionNotAllowed;
        case errSecDecode: return ZWKeychainErrorDecode;
        case errSecAuthFailed: return ZWKeychainErrorAuthFailed;
        default: return 0;
    }
}

static NSString *ZWKeychainErrorDesc(ZWKeychainErrorCode code) {
    switch (code) {
        case ZWKeychainErrorUnimplemented:
            return @"Function or operation not implemented.";
        case ZWKeychainErrorIO:
            return @"I/O error (bummers)";
        case ZWKeychainErrorOpWr:
            return @"ile already open with with write permission.";
        case ZWKeychainErrorParam:
            return @"One or more parameters passed to a function where not valid.";
        case ZWKeychainErrorAllocate:
            return @"Failed to allocate memory.";
        case ZWKeychainErrorUserCancelled:
            return @"User canceled the operation.";
        case ZWKeychainErrorBadReq:
            return @"Bad parameter or invalid state for operation.";
        case ZWKeychainErrorInternalComponent:
            return @"Inrernal Component";
        case ZWKeychainErrorNotAvailable:
            return @"No keychain is available. You may need to restart your computer.";
        case ZWKeychainErrorDuplicateItem:
            return @"The specified item already exists in the keychain.";
        case ZWKeychainErrorItemNotFound:
            return @"The specified item could not be found in the keychain.";
        case ZWKeychainErrorInteractionNotAllowed:
            return @"User interaction is not allowed.";
        case ZWKeychainErrorDecode:
            return @"Unable to decode the provided data.";
        case ZWKeychainErrorAuthFailed:
            return @"The user name or passphrase you entered is not";
        default:
            break;
    }
    return nil;
}

static NSString *ZWKeychainAccessibleStr(ZWKeychainAccessible e) {
    switch (e) {
        case ZWKeychainAccessibleWhenUnlocked:
            return (__bridge NSString *)(kSecAttrAccessibleWhenUnlocked);
        case ZWKeychainAccessibleAfterFirstUnlock:
            return (__bridge NSString *)(kSecAttrAccessibleAfterFirstUnlock);
        case ZWKeychainAccessibleAlways:
            return (__bridge NSString *)(kSecAttrAccessibleAlways);
        case ZWKeychainAccessibleWhenPasscodeSetThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly);
        case ZWKeychainAccessibleWhenUnlockedThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleWhenUnlockedThisDeviceOnly);
        case ZWKeychainAccessibleAfterFirstUnlockThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly);
        case ZWKeychainAccessibleAlwaysThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleAlwaysThisDeviceOnly);
        default:
            return nil;
    }
}

static ZWKeychainAccessible ZWKeychainAccessibleEnum(NSString *s) {
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlocked])
        return ZWKeychainAccessibleWhenUnlocked;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlock])
        return ZWKeychainAccessibleAfterFirstUnlock;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlways])
        return ZWKeychainAccessibleAlways;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly])
        return ZWKeychainAccessibleWhenPasscodeSetThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlockedThisDeviceOnly])
        return ZWKeychainAccessibleWhenUnlockedThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly])
        return ZWKeychainAccessibleAfterFirstUnlockThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlwaysThisDeviceOnly])
        return ZWKeychainAccessibleAlwaysThisDeviceOnly;
    return ZWKeychainAccessibleNone;
}

static id ZWKeychainQuerySynchonizationID(ZWKeychainQuerySynchronizationMode mode) {
    switch (mode) {
        case ZWKeychainQuerySynchronizationModeAny:
            return (__bridge id)(kSecAttrSynchronizableAny);
        case ZWKeychainQuerySynchronizationModeNo:
            return (__bridge id)kCFBooleanFalse;
        case ZWKeychainQuerySynchronizationModeYes:
            return (__bridge id)kCFBooleanTrue;
        default:
            return (__bridge id)(kSecAttrSynchronizableAny);
    }
}

static ZWKeychainQuerySynchronizationMode ZWKeychainQuerySynchonizationEnum(NSNumber *num) {
    if ([num isEqualToNumber:@NO]) return ZWKeychainQuerySynchronizationModeNo;
    if ([num isEqualToNumber:@YES]) return ZWKeychainQuerySynchronizationModeYes;
    return ZWKeychainQuerySynchronizationModeAny;
}


@interface ZWKeychainItem ()
@property (nonatomic, readwrite, strong) NSDate *modificationDate;
@property (nonatomic, readwrite, strong) NSDate *creationDate;
@end

@implementation ZWKeychainItem


- (void)setPasswordObject:(id <NSCoding> )object {
    self.passwordData = [NSKeyedArchiver archivedDataWithRootObject:object];
}

- (id <NSCoding> )passwordObject {
    if ([self.passwordData length]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:self.passwordData];
    }
    return nil;
}

- (void)setPassword:(NSString *)password {
    self.passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)password {
    if ([self.passwordData length]) {
        return [[NSString alloc] initWithData:self.passwordData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSMutableDictionary *)queryDic {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
    if (self.account) dic[(__bridge id)kSecAttrAccount] = self.account;
    if (self.service) dic[(__bridge id)kSecAttrService] = self.service;
    
    if (![UIDevice currentDevice].isSimulator) {
        // Remove the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
        //
        // The access group attribute will be included in items returned by SecItemCopyMatching,
        // which is why we need to remove it before updating the item.
        if (self.accessGroup) dic[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    if (kiOS7Later) {
        dic[(__bridge id)kSecAttrSynchronizable] = ZWKeychainQuerySynchonizationID(self.synchronizable);
    }
    
    return dic;
}

- (NSMutableDictionary *)dic {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
    if (self.account) dic[(__bridge id)kSecAttrAccount] = self.account;
    if (self.service) dic[(__bridge id)kSecAttrService] = self.service;
    if (self.label) dic[(__bridge id)kSecAttrLabel] = self.label;
    
    if (![UIDevice currentDevice].isSimulator) {
        // Remove the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
        //
        // The access group attribute will be included in items returned by SecItemCopyMatching,
        // which is why we need to remove it before updating the item.
        if (self.accessGroup) dic[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    if (kiOS7Later) {
        dic[(__bridge id)kSecAttrSynchronizable] = ZWKeychainQuerySynchonizationID(self.synchronizable);
    }
    
    if (self.accessible) dic[(__bridge id)kSecAttrAccessible] = ZWKeychainAccessibleStr(self.accessible);
    if (self.passwordData) dic[(__bridge id)kSecValueData] = self.passwordData;
    if (self.type != nil) dic[(__bridge id)kSecAttrType] = self.type;
    if (self.creater != nil) dic[(__bridge id)kSecAttrCreator] = self.creater;
    if (self.comment) dic[(__bridge id)kSecAttrComment] = self.comment;
    if (self.descr) dic[(__bridge id)kSecAttrDescription] = self.descr;
    
    return dic;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (dic.count == 0) return nil;
    self = self.init;
    
    self.service = dic[(__bridge id)kSecAttrService];
    self.account = dic[(__bridge id)kSecAttrAccount];
    self.passwordData = dic[(__bridge id)kSecValueData];
    self.label = dic[(__bridge id)kSecAttrLabel];
    self.type = dic[(__bridge id)kSecAttrType];
    self.creater = dic[(__bridge id)kSecAttrCreator];
    self.comment = dic[(__bridge id)kSecAttrComment];
    self.descr = dic[(__bridge id)kSecAttrDescription];
    self.modificationDate = dic[(__bridge id)kSecAttrModificationDate];
    self.creationDate = dic[(__bridge id)kSecAttrCreationDate];
    self.accessGroup = dic[(__bridge id)kSecAttrAccessGroup];
    self.accessible = ZWKeychainAccessibleEnum(dic[(__bridge id)kSecAttrAccessible]);
    self.synchronizable = ZWKeychainQuerySynchonizationEnum(dic[(__bridge id)kSecAttrSynchronizable]);
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ZWKeychainItem *item = [ZWKeychainItem new];
    item.service = self.service;
    item.account = self.account;
    item.passwordData = self.passwordData;
    item.label = self.label;
    item.type = self.type;
    item.creater = self.creater;
    item.comment = self.comment;
    item.descr = self.descr;
    item.modificationDate = self.modificationDate;
    item.creationDate = self.creationDate;
    item.accessGroup = self.accessGroup;
    item.accessible = self.accessible;
    item.synchronizable = self.synchronizable;
    return item;
}

- (NSString *)description {
    NSMutableString *str = @"".mutableCopy;
    [str appendString:@"YYKeychainItem:{\n"];
    if (self.service) [str appendFormat:@"  service:%@,\n", self.service];
    if (self.account) [str appendFormat:@"  service:%@,\n", self.account];
    if (self.password) [str appendFormat:@"  service:%@,\n", self.password];
    if (self.label) [str appendFormat:@"  service:%@,\n", self.label];
    if (self.type != nil) [str appendFormat:@"  service:%@,\n", self.type];
    if (self.creater != nil) [str appendFormat:@"  service:%@,\n", self.creater];
    if (self.comment) [str appendFormat:@"  service:%@,\n", self.comment];
    if (self.descr) [str appendFormat:@"  service:%@,\n", self.descr];
    if (self.modificationDate) [str appendFormat:@"  service:%@,\n", self.modificationDate];
    if (self.creationDate) [str appendFormat:@"  service:%@,\n", self.creationDate];
    if (self.accessGroup) [str appendFormat:@"  service:%@,\n", self.accessGroup];
    [str appendString:@"}"];
    return str;
}

@end



@implementation ZWKeychain

+ (NSString *)getPasswordForService:(NSString *)serviceName
                            account:(NSString *)account
                              error:(NSError **)error {
    if (!serviceName || !account) {
        if (error) *error = [ZWKeychain errorWithCode:errSecParam];
        return nil;
    }
    
    ZWKeychainItem *item = [ZWKeychainItem new];
    item.service = serviceName;
    item.account = account;
    ZWKeychainItem *result = [self selectOneItem:item error:error];
    return result.password;
}

+ (nullable NSString *)getPasswordForService:(NSString *)serviceName
                                     account:(NSString *)account {
    return [self getPasswordForService:serviceName account:account error:NULL];
}

+ (BOOL)deletePasswordForService:(NSString *)serviceName
                         account:(NSString *)account
                           error:(NSError **)error {
    if (!serviceName || !account) {
        if (error) *error = [ZWKeychain errorWithCode:errSecParam];
        return NO;
    }
    
    ZWKeychainItem *item = [ZWKeychainItem new];
    item.service = serviceName;
    item.account = account;
    return [self deleteItem:item error:error];
}

+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account {
    return [self deletePasswordForService:serviceName account:account error:NULL];
}

+ (BOOL)setPassword:(NSString *)password
         forService:(NSString *)serviceName
            account:(NSString *)account
              error:(NSError **)error {
    if (!password || !serviceName || !account) {
        if (error) *error = [ZWKeychain errorWithCode:errSecParam];
        return NO;
    }
    ZWKeychainItem *item = [ZWKeychainItem new];
    item.service = serviceName;
    item.account = account;
    ZWKeychainItem *result = [self selectOneItem:item error:NULL];
    if (result) {
        result.password = password;
        return [self updateItem:result error:error];
    } else {
        item.password = password;
        return [self insertItem:item error:error];
    }
}

+ (BOOL)setPassword:(NSString *)password
         forService:(NSString *)serviceName
            account:(NSString *)account {
    return [self setPassword:password forService:serviceName account:account error:NULL];
}

+ (BOOL)insertItem:(ZWKeychainItem *)item error:(NSError **)error {
    if (!item.service || !item.account || !item.passwordData) {
        if (error) *error = [ZWKeychain errorWithCode:errSecParam];
        return NO;
    }
    
    NSMutableDictionary *query = [item dic];
    OSStatus status = status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    if (status != errSecSuccess) {
        if (error) *error = [ZWKeychain errorWithCode:status];
        return NO;
    }
    
    return YES;
}

+ (BOOL)insertItem:(ZWKeychainItem *)item {
    return [self insertItem:item error:NULL];
}

+ (BOOL)updateItem:(ZWKeychainItem *)item error:(NSError **)error {
    if (!item.service || !item.account || !item.passwordData) {
        if (error) *error = [ZWKeychain errorWithCode:errSecParam];
        return NO;
    }
    
    NSMutableDictionary *query = [item queryDic];
    NSMutableDictionary *update = [item dic];
    [update removeObjectForKey:(__bridge id)kSecClass];
    if (!query || !update) return NO;
    OSStatus status = status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    if (status != errSecSuccess) {
        if (error) *error = [ZWKeychain errorWithCode:status];
        return NO;
    }
    
    return YES;
}

+ (BOOL)updateItem:(ZWKeychainItem *)item {
    return [self updateItem:item error:NULL];
}

+ (BOOL)deleteItem:(ZWKeychainItem *)item error:(NSError **)error {
    if (!item.service || !item.account) {
        if (error) *error = [ZWKeychain errorWithCode:errSecParam];
        return NO;
    }
    
    NSMutableDictionary *query = [item dic];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != errSecSuccess) {
        if (error) *error = [ZWKeychain errorWithCode:status];
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteItem:(ZWKeychainItem *)item {
    return [self deleteItem:item error:NULL];
}

+ (ZWKeychainItem *)selectOneItem:(ZWKeychainItem *)item error:(NSError **)error {
    if (!item.service || !item.account) {
        if (error) *error = [ZWKeychain errorWithCode:errSecParam];
        return nil;
    }
    
    NSMutableDictionary *query = [item dic];
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    query[(__bridge id)kSecReturnAttributes] = @YES;
    query[(__bridge id)kSecReturnData] = @YES;
    
    OSStatus status;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess) {
        if (error) *error = [[self class] errorWithCode:status];
        return nil;
    }
    if (!result) return nil;
    
    NSDictionary *dic = nil;
    if (CFGetTypeID(result) == CFDictionaryGetTypeID()) {
        dic = (__bridge NSDictionary *)(result);
    } else if (CFGetTypeID(result) == CFArrayGetTypeID()){
        dic = [(__bridge NSArray *)(result) firstObject];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    if (!dic.count) return nil;
    return [[ZWKeychainItem alloc] initWithDic:dic];
}

+ (ZWKeychainItem *)selectOneItem:(ZWKeychainItem *)item {
    return [self selectOneItem:item error:NULL];
}

+ (NSArray *)selectItems:(ZWKeychainItem *)item error:(NSError **)error {
    NSMutableDictionary *query = [item dic];
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    query[(__bridge id)kSecReturnAttributes] = @YES;
    query[(__bridge id)kSecReturnData] = @YES;
    
    OSStatus status;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess && error != NULL) {
        *error = [[self class] errorWithCode:status];
        return nil;
    }
    
    NSMutableArray *res = [NSMutableArray new];
    NSDictionary *dic = nil;
    if (CFGetTypeID(result) == CFDictionaryGetTypeID()) {
        dic = (__bridge NSDictionary *)(result);
        ZWKeychainItem *item = [[ZWKeychainItem alloc] initWithDic:dic];
        if (item) [res addObject:item];
    } else if (CFGetTypeID(result) == CFArrayGetTypeID()){
        for (NSDictionary *dic in (__bridge NSArray *)(result)) {
            ZWKeychainItem *item = [[ZWKeychainItem alloc] initWithDic:dic];
            if (item) [res addObject:item];
        }
    }
    
    return res;
}

+ (NSArray *)selectItems:(ZWKeychainItem *)item {
    return [self selectItems:item error:NULL];
}

+ (NSError *)errorWithCode:(OSStatus)osCode {
    ZWKeychainErrorCode code = ZWKeychainErrorCodeFromOSStatus(osCode);
    NSString *desc = ZWKeychainErrorDesc(code);
    NSDictionary *userInfo = desc ? @{ NSLocalizedDescriptionKey : desc } : nil;
    return [NSError errorWithDomain:@"com.ibireme.yykit.keychain" code:code userInfo:userInfo];
}


@end
