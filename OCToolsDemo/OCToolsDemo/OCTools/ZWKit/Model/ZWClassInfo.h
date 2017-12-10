//
//  ZWClassInfo.h
//  OCToolsDemo
//
//  Created by 周巍的Mac on 2017/12/10.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Type encoding's type.
 */
typedef NS_OPTIONS(NSUInteger, ZWEncodingType) {
    ZWEncodingTypeMask       = 0xFF, ///< mask of type value
    ZWEncodingTypeUnknown    = 0, ///< unknown
    ZWEncodingTypeVoid       = 1, ///< void
    ZWEncodingTypeBool       = 2, ///< bool
    ZWEncodingTypeInt8       = 3, ///< char / BOOL
    ZWEncodingTypeUInt8      = 4, ///< unsigned char
    ZWEncodingTypeInt16      = 5, ///< short
    ZWEncodingTypeUInt16     = 6, ///< unsigned short
    ZWEncodingTypeInt32      = 7, ///< int
    ZWEncodingTypeUInt32     = 8, ///< unsigned int
    ZWEncodingTypeInt64      = 9, ///< long long
    ZWEncodingTypeUInt64     = 10, ///< unsigned long long
    ZWEncodingTypeFloat      = 11, ///< float
    ZWEncodingTypeDouble     = 12, ///< double
    ZWEncodingTypeLongDouble = 13, ///< long double
    ZWEncodingTypeObject     = 14, ///< id
    ZWEncodingTypeClass      = 15, ///< Class
    ZWEncodingTypeSEL        = 16, ///< SEL
    ZWEncodingTypeBlock      = 17, ///< block
    ZWEncodingTypePointer    = 18, ///< void*
    ZWEncodingTypeStruct     = 19, ///< struct
    ZWEncodingTypeUnion      = 20, ///< union
    ZWEncodingTypeCString    = 21, ///< char*
    ZWEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    ZWEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    ZWEncodingTypeQualifierConst  = 1 << 8,  ///< const
    ZWEncodingTypeQualifierIn     = 1 << 9,  ///< in
    ZWEncodingTypeQualifierInout  = 1 << 10, ///< inout
    ZWEncodingTypeQualifierOut    = 1 << 11, ///< out
    ZWEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    ZWEncodingTypeQualifierByref  = 1 << 13, ///< byref
    ZWEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    ZWEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    ZWEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    ZWEncodingTypePropertyCopy         = 1 << 17, ///< copy
    ZWEncodingTypePropertyRetain       = 1 << 18, ///< retain
    ZWEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    ZWEncodingTypePropertyWeak         = 1 << 20, ///< weak
    ZWEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    ZWEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    ZWEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

/**
 Get the type from a Type-Encoding string.
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */
ZWEncodingType ZWEncodingGetType(const char *typeEncoding);


/**
 Instance variable information.
 */
@interface ZWClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;              ///< ivar opaque struct
@property (nonatomic, strong, readonly) NSString *name;         ///< Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset;       ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding
@property (nonatomic, assign, readonly) ZWEncodingType type;    ///< Ivar's type

/**
 Creates and returns an ivar info object.
 
 @param ivar ivar opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithIvar:(Ivar)ivar;
@end



/**
 Method information.
 */
@interface ZWClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;                  ///< method opaque struct
@property (nonatomic, strong, readonly) NSString *name;                 ///< method name
@property (nonatomic, assign, readonly) SEL sel;                        ///< method's selector
@property (nonatomic, assign, readonly) IMP imp;                        ///< method's implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding;         ///< method's parameter and return types
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;   ///< return value's type
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; ///< array of arguments' type

/**
 Creates and returns a method info object.
 
 @param method method opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithMethod:(Method)method;
@end



/**
 Property information.
 */
@interface ZWClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property; ///< property's opaque struct
@property (nonatomic, strong, readonly) NSString *name;           ///< property's name
@property (nonatomic, assign, readonly) ZWEncodingType type;      ///< property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding;   ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName;       ///< property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls;      ///< may be nil
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols; ///< may nil
@property (nonatomic, assign, readonly) SEL getter;               ///< getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter;               ///< setter (nonnull)

/**
 Creates and returns a property info object.
 
 @param property property opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithProperty:(objc_property_t)property;
@end



/**
 Class information for a class.
 */
@interface ZWClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls; ///< class object
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< class's meta class object
@property (nonatomic, readonly) BOOL isMeta; ///< whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name; ///< class name
@property (nullable, nonatomic, strong, readonly) ZWClassInfo *superClassInfo; ///< super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, ZWClassIvarInfo *> *ivarInfos; ///< ivars
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, ZWClassMethodInfo *> *methodInfos; ///< methods
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, ZWClassPropertyInfo *> *propertyInfos; ///< properties

/**
 If the class is changed (for example: you add a method to this class with
 'class_addMethod()'), you should call this method to refresh the class info cache.
 
 After called this method, `needUpdate` will returns `YES`, and you should call
 'classInfoWithClass' or 'classInfoWithClassName' to get the updated class info.
 */
- (void)setNeedUpdate;

/**
 If this method returns `YES`, you should stop using this instance and call
 `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.
 
 @return Whether this class info need update.
 */
- (BOOL)needUpdate;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClass:(Class)cls;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;
@end

NS_ASSUME_NONNULL_END
