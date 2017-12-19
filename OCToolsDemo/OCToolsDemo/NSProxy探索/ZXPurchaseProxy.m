//
//  ZXPurchaseProxy.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ZXPurchaseProxy.h"
#import <objc/message.h>

@interface ZXPurchaseProxy()
{
    ZXBookPrvider * _bookProvider;
    ZXClothesProvider * _clothesProvider;
    NSMutableDictionary * _methodsMap;
}
@end

@implementation ZXPurchaseProxy

#pragma mark 类方法
+(instancetype)gainProxy
{
    return [[ZXPurchaseProxy alloc]init];
}

#pragma mark 初始化方法
-(instancetype)init
{
    _methodsMap = [NSMutableDictionary dictionary];
    _bookProvider = [[ZXBookPrvider alloc]init];
    _clothesProvider = [[ZXClothesProvider alloc]init];
    
    //在字典中存储调用者和调用的方法
    [self registerMethodsWithTarget:_bookProvider];
    [self registerMethodsWithTarget:_clothesProvider];
    
    return self;
}

#pragma mark 添加方法
//添加方法进入字典中
-(void)registerMethodsWithTarget:(id)target
{
    unsigned int count=0;
    //获取调用者的方法的列表
    Method * methodList = class_copyMethodList([target class], &count);
    //把方法存储都字典中
    for(int i=0;i<count;i++){
            //获取方法
            Method temp = methodList[i];
            //获取方法编号
            SEL selector = method_getName(temp);
            //获取方法的名字
            const char * name = sel_getName(selector);
            //存储到字典中
            [_methodsMap setObject:target forKey:[NSString stringWithUTF8String:name]];
        }
    free(methodList);
}


#pragma mark NSProxy的方法
//生成方法签名
-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    //获取方法名
    NSString * name = NSStringFromSelector(sel);
    //寻找字典中的target
    id target = _methodsMap[name];
    //检查target
    if(target&&[target respondsToSelector:sel]){
        return [target methodSignatureForSelector:sel];
    }else{
        return [super methodSignatureForSelector:sel];
    }
}

//配发消息
-(void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = invocation.selector;
    //获取方法的名字
    NSString * name = NSStringFromSelector(sel);
    //查找调用者
    id target = _methodsMap[name];
    //检查调用者
    if(target&&[target respondsToSelector:sel]){
        [invocation invokeWithTarget:target];
    }else{
        [super forwardInvocation:invocation];
    }
}

@end
