//
//  OneViewController.m
//  KVRouterDemo
//
//  Created by kevin on 2018/4/2.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取到页面实例后再跳转
    UIViewController * vc = [KVRouter getObjectWithUrl:@"pushone?id=1"];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    //以下为快速push，需要提前设置全局导航控制器
//    [KVRouter openUrl:@"pushone"];
    //携带参数
//    [KVRouter openUrl:@"pushone?id=1"];
    //携带多参数
//    [KVRouter openUrl:@"pushone?id=1" parameter:@{@"user" : @"kevin"}];
    //传入导航控制器进行跳转
//    [KVRouter openUrl:@"pushone" withNavigationController:self.navigationController];
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
