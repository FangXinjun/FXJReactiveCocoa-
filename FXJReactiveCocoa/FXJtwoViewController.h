//
//  FXJtwoViewController.h
//  FXJReactiveCocoa
//
//  Created by myApplePro01 on 16/4/21.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSubject;
@interface FXJtwoViewController : UIViewController
@property (nonatomic, strong) RACSubject *delegateSignal;
@property (nonatomic, strong) UIButton        *testBtn;

@end
