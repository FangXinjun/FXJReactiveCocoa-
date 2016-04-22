//
//  FXJtwoViewController.m
//  FXJReactiveCocoa
//
//  Created by myApplePro01 on 16/4/21.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "FXJtwoViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface FXJtwoViewController ()

@end

@implementation FXJtwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
        
    self.testBtn=   [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _testBtn.backgroundColor = [UIColor purpleColor];
    [_testBtn
     addTarget:self action:@selector(twoBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    _testBtn.center = self.view.center;
    [self.view addSubview:_testBtn];

}

- (void)twoBtnclick:(UIButton *)btn{
    // 通知第一个控制器，告诉它，按钮被点了
    // 通知代理
    // 判断代理信号是否有值
    if (self.delegateSignal) {
        // 有值，才需要通知
        [self.delegateSignal sendNext:@"2按钮点击了"];
    }
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
