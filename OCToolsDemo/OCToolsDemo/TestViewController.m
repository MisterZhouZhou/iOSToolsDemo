//
//  TestViewController.m
//  OCToolsDemo
//
//  Created by chengfei on 2017/12/19.
//  Copyright © 2017年 chengfei. All rights reserved.
//

#import "TestViewController.h"
#import "WeakProxy.h"
#import "ZWWeakProxy.h"

@interface TestViewController ()

@property (strong,nonatomic)NSTimer * timer;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:[ZWWeakProxy proxyWithTarget:self]
                                       selector:@selector(timerInvoked:)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerInvoked:(NSTimer *)timer{
    NSLog(@"1");
}
- (void)dealloc{
    NSLog(@"Dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
