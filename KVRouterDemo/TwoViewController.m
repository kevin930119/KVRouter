//
//  TwoViewController.m
//  KVRouterDemo
//
//  Created by kevin on 2018/4/2.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "TwoViewController.h"
#import "PresentTwoController.h"

@interface TwoViewController () <PresentTwoControllerDelegate>

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //这个页面是通过配置文件进行注册的，仅能通过init方法初始化
    //如果需要在该控制器在包装一层导航栏，可以获取到该控制器实例后再自行包装
//    UIViewController * vc = [KVRouter getObjectWithUrl:@"presenttwo"];
//    if (vc) {
//        [self presentViewController:vc animated:YES completion:nil];
//    }
    //快速present
//    [KVRouter presentUrl:@"presenttwo"];
    //携带参数
//    [KVRouter presentUrl:@"presenttwo?id=1"];
    //携带多参数，设置代理，协议代理是一种强耦合关系，无法取消
    PresentTwoController * vc = (PresentTwoController*)[KVRouter presentUrl:@"presenttwo?id=1" parameter:@{@"user" : @"kevin"}];
    vc.delegate = self;
    //传入来源控制器进行present
//    [KVRouter presentUrl:@"presenttwo" sourceViewController:self];
}

- (void)dismissbackWithParameter:(NSDictionary *)parameter {
    NSLog(@"协议代理生效%@", parameter);
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
