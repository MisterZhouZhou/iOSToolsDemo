//
//  ZWFileHash.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/20.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// File hash algorithm type
typedef NS_OPTIONS (NSUInteger, ZWFileHashType) {
    ZWFileHashTypeMD2     = 1 << 0, ///< MD2 hash
    ZWFileHashTypeMD4     = 1 << 1, ///< MD4 hash
    ZWFileHashTypeMD5     = 1 << 2, ///< MD5 hash
    ZWFileHashTypeSHA1    = 1 << 3, ///< SHA1 hash
    ZWFileHashTypeSHA224  = 1 << 4, ///< SHA224 hash
    ZWFileHashTypeSHA256  = 1 << 5, ///< SHA256 hash
    ZWFileHashTypeSHA384  = 1 << 6, ///< SHA384 hash
    ZWFileHashTypeSHA512  = 1 << 7, ///< SHA512 hash
    ZWFileHashTypeCRC32   = 1 << 8, ///< crc32 checksum
    ZWFileHashTypeAdler32 = 1 << 9, ///< adler32 checksum
};

/**
 Utility for computing hashes of file with high performance and low memory usage.
 See `YYFileHashType` for all supported hash (checksum) type.
 
 Sample Code:
 
 YYFileHash *hash = [YYFileHash hashForFile:@"/tmp/Xcode6.dmg" types:YYFileHashTypeMD5 | YYFileHashTypeSHA1];
 NSLog(@"md5:%@ sha1:%@", hash.md5String, hash.sha1String);
 
 */
@interface ZWFileHash : NSObject

/**
 Start calculate file hash and return the result.
 
 @discussion The calling thread is blocked until the asynchronous hash progress
 finished.
 
 @param filePath The path to the file to access.
 
 @param types    File hash algorithm types.
 
 @return File hash result, or nil when an error occurs.
 */
+ (nullable ZWFileHash *)hashForFile:(NSString *)filePath types:(ZWFileHashType)types;

/**
 Start calculate file hash and return the result.
 
 @discussion The calling thread is blocked until the asynchronous hash progress
 finished or cancelled.
 
 @param filePath The path to the file to access.
 
 @param types    File hash algorithm types.
 
 @param block    A block which is called in progress. The block takes 3 arguments:
 `totalSize` is the total file size in bytes;
 `processedSize` is the processed file size in bytes;
 `stop` is a reference to a Boolean value, which can be set to YES to stop
 further processing. If the block stop the processing, it just returns nil.
 
 @return File hash result, or nil when an error occurs.
 */
+ (nullable ZWFileHash *)hashForFile:(NSString *)filePath
                               types:(ZWFileHashType)types
                          usingBlock:(nullable void (^)(UInt64 totalSize, UInt64 processedSize, BOOL *stop))block;


@property (nonatomic, readonly) ZWFileHashType types; ///< hash type

@property (nullable, nonatomic, strong, readonly) NSString *md2String; ///< md2 hash string in lowercase
@property (nullable, nonatomic, strong, readonly) NSString *md4String; ///< md4 hash string in lowercase
@property (nullable, nonatomic, strong, readonly) NSString *md5String; ///< md5 hash string in lowercase
@property (nullable, nonatomic, strong, readonly) NSString *sha1String; ///< sha1 hash string in lowercase
@property (nullable, nonatomic, strong, readonly) NSString *sha224String; ///< sha224 hash string in lowercase
@property (nullable, nonatomic, strong, readonly) NSString *sha256String; ///< sha256 hash string in lowercase
@property (nullable, nonatomic, strong, readonly) NSString *sha384String; ///< sha384 hash string in lowercase
@property (nullable, nonatomic, strong, readonly) NSString *sha512String; ///< sha512 hash string in lowercase
@property (nullable, nonatomic, strong, readonly) NSString *crc32String; ///< crc32 checksum string in lowercase
@property (nullable, nonatomic, strong, readonly) NSString *adler32String; ///< adler32 checksum string in lowercase

@property (nullable, nonatomic, strong, readonly) NSData *md2Data; ///< md2 hash
@property (nullable, nonatomic, strong, readonly) NSData *md4Data; ///< md4 hash
@property (nullable, nonatomic, strong, readonly) NSData *md5Data; ///< md5 hash
@property (nullable, nonatomic, strong, readonly) NSData *sha1Data; ///< sha1 hash
@property (nullable, nonatomic, strong, readonly) NSData *sha224Data; ///< sha224 hash
@property (nullable, nonatomic, strong, readonly) NSData *sha256Data; ///< sha256 hash
@property (nullable, nonatomic, strong, readonly) NSData *sha384Data; ///< sha384 hash
@property (nullable, nonatomic, strong, readonly) NSData *sha512Data; ///< sha512 hash
@property (nonatomic, readonly) uint32_t crc32; ///< crc32 checksum
@property (nonatomic, readonly) uint32_t adler32; ///< adler32 checksum


@end

NS_ASSUME_NONNULL_END
