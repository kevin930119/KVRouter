//
//  PushOneController.m
//  KVRouterDemo
//
//  Created by kevin on 2018/4/2.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "PushOneController.h"

@interface PushOneController ()

@end

@implementation PushOneController

+ (void)load {
    //正常注册，内部使用init进行页面的初始化
//    [KVRouter registerUrl:@"pushone" withClass:[self class]];
    //自定义注册
    [KVRouter registerUrl:@"pushone" withClass:[self class] toHandler:^UIViewController *(NSDictionary *parameter) {
        //如果该页面是需要登录才能访问，可以在这里加一个判定，然后返回nil，避免逻辑错误
//        if (未登录) {
//            return nil;
//        }
        //实现自定义初始化
        PushOneController * vc = [PushOneController new];
        //也可以在这里进行赋值或者其他初始化逻辑
        return vc;
    }];
}

- (void)router:(KVRouter *)router getParameter:(NSDictionary *)parameter {
    NSLog(@"%@\n接收参数%@", NSStringFromClass([self class]), parameter);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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
