//
//  FXJViewController.m
//  FXJAppDelegate
//
//  Created by myApplePro01 on 16/4/21.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "FXJViewController.h"
#import "FXJtwoViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FXJDataModel.h"


@interface FXJViewController ()

@end

@implementation FXJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"我的标题";
    
    //1 KVO
    [[self rac_valuesAndChangesForKeyPath:@"myKVOPro" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"myKVOPro = %@",x);
    }];
    
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出 %@",x);
    }];
//
    
    UIButton *btn =   [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.backgroundColor = [UIColor yellowColor];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
    UILabel *testlable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
    testlable.backgroundColor = [UIColor greenColor];
    [self.view addSubview:testlable];

    
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"oneVC按钮被点击了");
        [self btnclick:nil];
        
        testlable.text = @"监控属性";
    }];
    
    UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(btn.frame), 100, 30)];
    textFiled.backgroundColor = [UIColor grayColor];
    textFiled.tintColor = [UIColor purpleColor];
    textFiled.placeholder = @"请输入文字";
    [self.view addSubview:textFiled];
    
    // 只要文本框文字改变，就会修改label的文字
    RAC(testlable,text) = textFiled.rac_textSignal;
    //监听某个对象的某个属性,返回的是信号
    [RACObserve(testlable,text) subscribeNext:^(id x) {
        NSLog(@"RACObserve = %@",x);
    }];
    
    // 5.监听文本框的文字改变
    [textFiled.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];

    [self requestResult];
    
    
    
//      [self UseRACSignal];
//    [self UseRACSubject];
//    [self UseRACReplaySubject];
//    [self arrayAndDict];
}

- (void)UseRACSignal{
   
    // 1.创建信号
    RACSignal *singanl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻：每当有订阅者订阅信号，就会调用block
        // 2.发送信号
        [subscriber sendNext:@1];
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁");
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [singanl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];

}


- (void)UseRACSubject{
  //  1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
   // RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
    RACSubject *subject = [RACSubject subject];
    
    [subject  subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者%@",x);
    } ];
    
    [subject sendNext:@"3"];
}

- (void)UseRACReplaySubject{

    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];

}

- (void)btnclick:(UIButton *)btn {
    FXJtwoViewController *twoVC =[[FXJtwoViewController alloc] init];
    // 设置代理信号
    twoVC.delegateSignal = [RACSubject subject];
    __weak __typeof__(self) weakSelf = self;
    // 订阅代理信号
    [twoVC.delegateSignal subscribeNext:^(id x) {
        NSLog(@"delegate = %@",x);
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        strongSelf.myKVOPro = @"tesmyKVOPro";
    }];
    
    [self.navigationController pushViewController:twoVC animated:YES];
}

- (void)arrayAndDict{
//RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
//    // 1.遍历数组
//    NSArray *numbers = @[@1,@2,@3,@4,@11,@21,@13,@42];
//    
//    // 这里其实是三步
//    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
//    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
//    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
//    [numbers.rac_sequence.signal subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
//    
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
//                NSString *key = x[0];
//                NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
        
    }];
}

// 字典转模型
- (void)modelWithDict:(NSArray *)array{
    // 3.2 RAC写法  遍历字典数组转模型
    
    // 3.3 RAC高级写法:
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
        
        return [FXJDataModel flagWithDict:value];
        
    }] array];
    NSLog(@"%@",flags);
}


- (void)requestResult{

    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];

}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
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
