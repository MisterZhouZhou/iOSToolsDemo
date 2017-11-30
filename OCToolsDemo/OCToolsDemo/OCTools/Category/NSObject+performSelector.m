//
//  NSObject+performSelector.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/30.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "NSObject+performSelector.h"

@implementation NSObject (performSelector)

- (id)performSelector:(SEL)aSelector withTheObjects:(NSArray*)objects{
    //1、创建签名对象
    //  NSMethodSignature*signature = [self methodSignatureForSelector:aSelector];
    NSMethodSignature*signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    //2、判断传入的方法是否存在
    if (!signature) {
        //传入的方法不存在 就抛异常
        NSString*info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
        @throw [[NSException alloc] initWithName:@"方法没有" reason:info userInfo:nil];
        return nil;
    }
    //3、创建NSInvocation对象
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
    //4、保存方法所属的对象
    invocation.target = self;           // index 0
    invocation.selector = aSelector;    // index 1
    
    //5、设置参数
    NSInteger arguments = signature.numberOfArguments -2;
    NSUInteger objectsCount = objects.count;
    NSInteger count = MIN(arguments, objectsCount);
    [self setInv:invocation andArgs:objects argsCount:count];
    
    //6、调用NSinvocation对象
    [invocation invoke];
    
    //7、获取返回值
    id res = nil;
    if (signature.methodReturnLength ==0) return nil;
    //getReturnValue获取返回值
    [invocation getReturnValue:&res];
    return res;
}

- (nullable id)performSelectorWithTheArgs:(SEL)sel, ...{
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    if (!sig) { [self doesNotRecognizeSelector:sel]; return nil; }
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    if (!inv) { [self doesNotRecognizeSelector:sel]; return nil; }
    // 设置消息接收者
    [inv setTarget:self];   // index = 0
    // 设置调用的方法
    [inv setSelector:sel];  // index = 1
    // 获取参数
    va_list args;
    va_start(args, sel);
    [self setInv:inv sigT:sig andArgs:args];
    va_end(args);
    [inv invoke];
    // 获取返回值
    id res = nil;
    if (sig.methodReturnLength ==0) return nil;
    //getReturnValue获取返回值
    [inv getReturnValue:&res];
    return res;
}

#pragma mark - 传递一个值的block
- (void)performSelectorWithTheBlock:(void(^)(int value))block {
    // 获取block
    NSMethodSignature *signature = aspect_blockMethodSignature(block,NULL);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:block];
    // 此处待考虑
    int a=2;
    [invocation setArgument:&a atIndex:1];
    [invocation invoke];
}


- (void)setInv:(NSInvocation *)inv andArgs:(NSArray *)args argsCount:(NSUInteger)count{
    for (int i = 0; i<count; i++) {
        NSObject*obj = args[i];
        //处理参数是NULL类型的情况
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        [inv setArgument:&obj atIndex:i+2];
    }
}

- (void)setInv:(NSInvocation *)inv sigT:(NSMethodSignature*)sig andArgs:(va_list)args{
    NSUInteger count = [sig numberOfArguments];
    for (int index = 2; index < count; index++) {
        id tmpStr = va_arg(args, id);
        if([tmpStr isKindOfClass:[NSNull class]]) tmpStr = nil;
        [inv setArgument:&tmpStr atIndex:index];
    }
}

@end
