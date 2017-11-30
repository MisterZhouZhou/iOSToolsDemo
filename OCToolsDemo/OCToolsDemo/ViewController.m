//
//  ViewController.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/11/16.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "ViewController.h"
#import "TextView.h"
#import "NSObject+performSelector.h"
#import "ZWKit.h"
#import <objc/runtime.h>



ZWSYNTH_DUMMY_CLASS(Person)

@interface Person: NSObject
@property (nonatomic, assign) NSInteger age;
@end
@implementation Person
@end




@interface ViewController (MethodAdd)
@end
@implementation ViewController (MethodAdd)

- (void)testAddObserverBlockForKeyPath{
    Person *person = [Person new];
    [person addObserverBlockForKeyPath:@"age" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        NSLog(@"%@", obj);
    }];
    person.age = 10;
}

- (void)testPerformMethod{
    [self performSelectorWithArgs:@selector(printStr:) afterDelay:2,@"hello zw"];
}

- (void)testCallMethod{
    //    //type1
    //    [self printStr1:@"hello world 1"];
    //
    //    //type2
    //    [self performSelector:@selector(printStr1:) withObject:@"hello world 2"];
    
    // type3
    [self invocationBlock];
}

- (void)invocationBlock{
    void (^block1)(int) = ^(int a){
        NSLog(@"block1 %d",a);
    };
    
    //type1
    block1(1);
    
    //type2
    //获取block类型对应的方法签名。
    NSMethodSignature *signature = aspect_blockMethodSignature(block1,NULL);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:block1];
    int a=2;
    [invocation setArgument:&a atIndex:1];
    [invocation invoke];
    
}

//代码来自 Aspect
// Block internals.
typedef NS_OPTIONS(int, AspectBlockFlags) {
    AspectBlockFlagsHasCopyDisposeHelpers = (1 << 25),
    AspectBlockFlagsHasSignature          = (1 << 30)
};
typedef struct _AspectBlock {
    __unused Class isa;
    AspectBlockFlags flags;
    __unused int reserved;
    void (__unused *invoke)(struct _AspectBlock *block, ...);
    struct {
        unsigned long int reserved;
        unsigned long int size;
        // requires AspectBlockFlagsHasCopyDisposeHelpers
        void (*copy)(void *dst, const void *src);
        void (*dispose)(const void *);
        // requires AspectBlockFlagsHasSignature
        const char *signature;
        const char *layout;
    } *descriptor;
    // imported variables
} *AspectBlockRef;

static NSMethodSignature *aspect_blockMethodSignature(id block, NSError **error) {
    AspectBlockRef layout = (__bridge void *)block;
    if (!(layout->flags & AspectBlockFlagsHasSignature)) {
        NSString *description = [NSString stringWithFormat:@"The block %@ doesn't contain a type signature.", block];
        //        AspectError(AspectErrorMissingBlockSignature, description);
        return nil;
    }
    void *desc = layout->descriptor;
    desc += 2 * sizeof(unsigned long int);
    if (layout->flags & AspectBlockFlagsHasCopyDisposeHelpers) {
        desc += 2 * sizeof(void *);
    }
    if (!desc) {
        NSString *description = [NSString stringWithFormat:@"The block %@ doesn't has a type signature.", block];
        //        AspectError(AspectErrorMissingBlockSignature, description);
        return nil;
    }
    const char *signature = (*(const char **)desc);
    return [NSMethodSignature signatureWithObjCTypes:signature];
}


- (void)invocationMethod{
    //该方式经常用于消息转发
    // 获取方法签名
    NSMethodSignature *sigOfPrintStr = [self methodSignatureForSelector:@selector(printStr:)];
    // 获取方法签名对应的invocation
    NSInvocation *incocationOfPrintStr = [NSInvocation invocationWithMethodSignature:sigOfPrintStr];
    /**设置消息接受者*/
    [incocationOfPrintStr setTarget:self];
    // [invocationOfPrintStr setArgument:(__bridge void * _Nonnull)(self) atIndex:0]; 与上等价
    /**设置要执行的selector*/
    [incocationOfPrintStr setSelector:@selector(printStr:)];
    // [invocationOfPrintStr setArgument:@selector(printStr1:) atIndex:1]; 与上等价
    //设置参数
    NSString *str = @"hello world 3";
    [incocationOfPrintStr setArgument:&str atIndex:2];
    // 开始执行
    [incocationOfPrintStr invoke];
}


- (void)printStr:(NSString*)str{
    NSLog(@"printStr1  %@",str);
}

- (void)testTime{
    NSLog(@"%@",ZWCompileTime());
}

- (void)baocunStruct{
    self.myPoint = CGPointMake(10, 20);
    NSLog(@"%@",NSStringFromCGPoint(self.myPoint));
}

-(void)setMyPoint:(CGPoint)myPoint{
    [self willChangeValueForKey:@"myPoint"];
    // 获取对象类型 {NSString=#}
    //NSLog(@"%s", @encode(NSString));
    NSValue *value = [NSValue value:&myPoint withObjCType:@encode(CGPoint)];
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"myPoint"];
}

- (CGPoint)myPoint{
    CGPoint cValue = { 0 };
    NSValue *value = objc_getAssociatedObject(self, @selector(setMyPoint:));
    [value getValue:&cValue];
    return cValue;
}


- (void)testTextView{
    //    NSURL *url = [[NSURL alloc] initWithString:@"http://www.baidu.com"];
    //    CFURLRef ref = (__bridge CFURLRef)url;
    //    NSLog(@"%@",ref);
    
    //    NSString *src = @"其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 ";
    //    NSMutableAttributedString * mabstring = [[NSMutableAttributedString alloc]initWithString:src];
    //    long slen = [mabstring length];
    //    NSLog(@"%ld",slen);
    //    // 将属性字串放到frame当中。
    //    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabstring);
    //    CGMutablePathRef path = CGPathCreateMutable();
    //    // 添加文本范围
    //    CGPathAddRect(path, NULL, CGRectMake(10, 10, self.view.bounds.size.width - 20, self.view.bounds.size.height - 20));
    //    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    //    [src drawInRect:frame withAttributes:nil];
    
    
    //    TextView *testView = [[TextView alloc]initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 60)];
    //    testView.backgroundColor = [UIColor lightGrayColor];
    //    [self.view addSubview:testView];
}


@end





@interface ViewController ()
@property (nonatomic, assign) CGPoint myPoint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 30, 30)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
//    [view performSelector:@selector(setBackgroundColor:) withTheObjects:@[[UIColor greenColor]]];
    [view performSelectorWithTheArgs:@selector(setBackgroundColor:), [UIColor greenColor], [UIColor yellowColor]];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

