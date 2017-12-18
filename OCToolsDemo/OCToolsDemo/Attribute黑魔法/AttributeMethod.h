//
//  AttributeMethod.h
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/11.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * example
 * - (void)testDeprecated ZWDEPRECATED();
 * - (void)testDeprecated ZWDEPRECATED("hh");
 */
#define ZWDEPRECATED(des) __attribute__((deprecated(des)))

/**
 * example
 * - (void)testUnavailabled ZWUNAVAILABLE();
 * - (void)testUnavailabled ZWUNAVAILABLE("不可用哦");
 */
#define ZWUNAVAILABLE(des) __attribute__((unavailable(des)))


@interface AttributeMethod : NSObject

/**
 *  1、deprecated
 *  在编译时会报过时警告, 用途： 提示该方法为过时方法单仍然可以用,属性和方法同样适用，
 *  DEPRECATED_ATTRIBUTE的作用和 __attribute__((deprecated("")))一样
 *  系统宏 DEPRECATED_ATTRIBUTE        __attribute__((deprecated))
 */
@property(nonatomic, strong) id deprecatedProperty DEPRECATED_ATTRIBUTE;

- (void)methodDeprecated:(NSString *)str __attribute__((deprecated("请使用#method")));

- (void)method:(NSString *)str;

- (void)methodSys DEPRECATED_ATTRIBUTE; //DEPRECATED_ATTRIBUTE是系统的宏，不带提示信息

- (void)methodMine __attribute__((deprecated)); // 不带提示信息


/**
 *  2、unavailable
 *  告诉编译器方法不可用, 用途：提示该方法或者属性不可用， 自定义了初始化方法，为了防止别人调用init初始化，那么可以这样。
 *  该属性和方法不会进行提示
 *  系统UNAVAILABLE_ATTRIBUTE __attribute__((unavailable))
 */
@property(nonatomic, strong) id unAvailableProperty NS_UNAVAILABLE; //NS_UNAVAILABLE是系统的宏

- (instancetype)copyWithName:(NSString *)name NS_UNAVAILABLE; //NS_UNAVAILABLE是系统的宏

- (void)methodUnAvailble1 UNAVAILABLE_ATTRIBUTE;

- (void)methodUnAvailble2 __attribute__((unavailable("此方法不可用")));

- (void)methodUnAvailble3 __attribute__((unavailable));

/**
 *  3、cleanup
 *  描述： 它主要作用于变量，当变量的作用域结束时，会调用指定的函数。
 */
- (void)useCleanUp;

- (void)createBlock;

/**
 *  4、availability
 *  描述： 这个参数是指定变量（方法）的使用版本范围
 *  introduced：第一次出现的版本。
 *  deprecated：声明要废弃的版本，意味着用户要迁移为其他API
 *  obsoleted： 声明移除的版本，意味着完全移除，再也不能使用它
 *  unavailable：在这些平台都不可用
 *  message 一些关于废弃和移除的信息
 */

- (void)methodUseRange NS_DEPRECATED_IOS(2_0, 3_0); // iOS2.0开始使用，3.0废弃

#define NS_DEPRECATED_IOS(_iosIntro, _iosDep, ...) CF_DEPRECATED_IOS(_iosIntro, _iosDep, __VA_ARGS__)

#define CF_DEPRECATED_IOS(_iosIntro, _iosDep, ...) __attribute__((availability(ios,introduced=_iosIntro,deprecated=_iosDep,message="" __VA_ARGS__)))

- (void)method4 NS_DEPRECATED_IOS(2_0, 3_0,"不推荐这个方法");
- (void)method5 CF_DEPRECATED_IOS(4_0, 5_0,"不推荐就不推荐");
- (void)method6 __attribute__((availability(ios,introduced=3_0,deprecated=7_0,message="3-7才推荐使用")));
- (void)method7 __attribute__((availability(ios,unavailable,message="iOS平台你用个屁啊")));
- (void)method8 __attribute__((availability(ios,introduced=3_0,deprecated=7_0,obsoleted=8_0,message="3-7才可以用，8平台上不能用")));


/**
 *  5、overloadable
 *  这个属性用在C的函数上实现像java一样方法重载
 */
__attribute__((overloadable)) void add(int num){
    NSLog(@"Add Int %i",num);
}

__attribute__((overloadable)) void add(NSString * num){
    NSLog(@"Add NSString %@",num);
}

__attribute__((overloadable)) void add(NSNumber * num){
    NSLog(@"Add NSNumber %@",num);
}


/**
 *  6、 objc_designated_initializer
 *  这个属性是指定内部实现的初始化方法。
 */
- (instancetype)initNoDesignated;

- (instancetype)initNoDesignated12 NS_DESIGNATED_INITIALIZER;

- (instancetype)initDesignated __attribute__((objc_designated_initializer));




/**
 *  7、objc_subclassing_restricted
 *  这个顾名思义就是相当于java的final关键字了，意是说它不能有子类。用于类, 如果有子类继承他的话，就会报错
 */


/**
 *  8、objc_requires_super
 *  这个也挺有意思的，意思是子类重写这个方法的时候，必须调用[super xxx]
 */

#define NS_REQUIRES_SUPER __attribute__((objc_requires_super))
- (void)method2 __attribute__((objc_requires_super));


@end

NS_CLASS_AVAILABLE_IOS(2_0) @interface ZWMCLassTest

@end


#pragma mark method 7
__attribute__((objc_subclassing_restricted)) //Final类 ,java的final关键字
@interface CustomObject : NSObject

@end
