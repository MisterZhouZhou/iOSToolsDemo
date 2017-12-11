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
#import "UIImage+QRCode.h"
#import "AttributeMethod.h"


ZWSYNTH_DUMMY_CLASS(Person)

@interface Person: NSObject
@property (nonatomic, assign) NSInteger age;
@end
@implementation Person
@end




@interface ViewController (MethodAdd)

- (void)testDeprecated1 ZWDEPRECATED();
- (void)testDeprecated2 ZWDEPRECATED("hh");

@end
@implementation ViewController (MethodAdd)

#pragma mark - sscanf 很强大
- (void)sscanfTest{
    // sscanf()是C语言中的函数
    // sscanf()的作用：  从一个字符串中读取与指定格式相符的数据
    // format 是格式控制字符串，它包含控制字符（如：%d,%i,%s等），空白字符（如：空格、制表符\t、回车换行符\n 或其连续组合）以及非空白字符，正则表达式等等；
    // 例子：
    
    /***    类型输出    ***/
    // 输出int类型
    // int result = 0;
    // sscanf([@"123321" UTF8String], "%d", &result);
    // 123321
    
    // 输出NSInteger类型
    //  NSInteger result = 0;
    //  sscanf([@"123321" UTF8String], "%ld", &result);
    // 123321
    
    // 输出char类型
    // char buffer[256];
    // sscanf([@"123321" UTF8String], "%s", buffer);
    // "123321"
    
    
    // 16进制数输出 u_int32_t
    // uint32_t result = 0;
    // sscanf([@"0x7f90d1d0bd60" UTF8String], "%x", &result);
    // 3520118112
    
    /***    格式化输出    ***/
    // 取指定长度的字符串
    // char result[3];
    // sscanf([@"123456" UTF8String], "%3s", result);
    // 123
    
    // 正则1
    // char result[256];
    // sscanf([@"121212abcFFF344" UTF8String], "%[1-9a-z]", result);
    // 121212abc
    
    // 正则2
    // char result[256];
    // sscanf([@"121212abcFFF344" UTF8String], "%[^A-Z]", result);
    // 121212abc
    
    // 正则3  获取 / 和 @ 之间的字符串
    // char result[256];
    // sscanf([@"iios/12DDWDFF@122" UTF8String], "%*[^/]/%s", result);
    // sscanf([@"iios/12DDWDFF@122" UTF8String], "%*[^/]/%[^@]", result);
    // 12DDWDFF
    
    // 正则4  截取字符串
    // char result[256];
    // sscanf([@"hello zw" UTF8String], "%*s%s", result);
    // %*s 表示第一个匹配到的%s被过滤掉
    // 12DDWDFF
    
    
    // 正则5
    // int a,b,c = 0;
    // sscanf([@"17:12:06" UTF8String], "%d:%d:%d", &a,&b,&c);
    // a: 17, b: 12, c: 6
    
    // 正则6
    char sztime1[16] = "", sztime2[16] = "";
    sscanf("2006:03:18 - 2006:04:18", "%[0-9,:] - %[0-9,:]", sztime1, sztime2);
    
    printf("\n");
}

- (void)test1{
    NSLog(@"%u", [UIColor redColor].rgbValue);
}

- (void)test{
    //    NSString *xml = @"<Book><title>阿凡达</title><price>198.0</price></Book>";
    //    NSDictionary *dict = [NSDictionary dictionaryWithXML:xml];
    //    NSLog(@"%@",dict);
    
    //    NSLog(@"%c", @"60".charValue);
    //    [@"  hello" isNotBlank];
    
    //    CGFloat scale = [@"hello@22x.jpg" pathScale];
    //    NSLog(@"%.2f",scale);
    //   // hello@2x
    //   NSLog(@"%@",  [@"hello.jpg" stringByAppendingNameScale:2.0]);
    //   NSLog(@"%@",  [@"hello.jpg" stringByAppendingPathScale:2.0]);
}

- (void)qCode{
    //    UIImage *img = [UIImage imageNamed:@"qcode.png"];
    UIImage *img = [UIImage qrImageWithString:@"hello zw" size:CGSizeMake(100, 100) color:nil backGroundColor: nil];
    //    UIImage *img = [UIImage generateBarCode:@"hello zw" size:CGSizeMake(100, 50) color:nil backGroundColor:nil];
    [img readQRCodeWithMyQRCode:^(NSString *qrString, NSError *error) {
        NSLog(@"%@",qrString);
    }];
}

- (void)testString1{
     NSLog(@"%@",[@"hello  world!  " stringByTrim]);
    
    //    NSLog(@"%@",[@"<h1>hello</h1>" stringByEscapingHTML]);
    
    //    [NSData dataWithHexString:[[@"hello" dataUsingEncoding:NSUTF8StringEncoding] hexString]];
    
    //    NSLog(@"%@",[@"hello" dataUsingEncoding:NSUTF8StringEncoding]);
    //
    //    NSLog(@"%@",[[@"hello" dataUsingEncoding:NSUTF8StringEncoding] hexString]);

}

- (void)testPerformSelector{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 30, 30)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    //    [view performSelector:@selector(setBackgroundColor:) withTheObjects:@[[UIColor greenColor]]];
    [view performSelectorWithTheArgs:@selector(setBackgroundColor:), [UIColor greenColor], [UIColor yellowColor]];

}

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

   // [[AttributeMethod new] methodDeprecated:@"method1"];
   //    [AttributeMethod new].deprecatedProperty;
   //    [AttributeMethod new].unAvailableProperty;
   //    [self testDeprecated];
    
   [[AttributeMethod new] useCleanUp];
   [[AttributeMethod new] createBlock];
}

- (void)test{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor blueColor];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc.view addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [view addGestureRecognizer:tap];
}

- (void)close{
    NSLog(@"ddd");
}

- (void)transformLate{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = UIColor.blueColor;
    [self.view addSubview:view];
    
    // width1 = a*width + c*height + tx = 0.2*width + 0 + 0 = 20
    // height1 = b*width + dy*height + ty =  0*width + 1*height + 0 = 100
    view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    NSLog(@"%@", NSStringFromCGRect(view.frame));
    NSLog(@"%@", NSStringFromCGPoint(view.center));
    // {{140, 100}, {20, 100}}
    
    // 结论：
    // x会跟着c的值进行拉伸(View的宽度是跟着改变)
    // y会跟着b的值进行拉伸（View的高度跟着改变）
    // c和b的值改变不会影响到View的point（center中心点）
    // x会跟着t.x进行x做表平移，y会跟着t.y进行平移。这里的point（center）是跟着变换的。
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

