//
//  PresentTwoController.m
//  KVRouterDemo
//
//  Created by kevin on 2018/4/2.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "PresentTwoController.h"

@interface PresentTwoController ()

@property (nonatomic, strong) NSDictionary * param;

@end

@implementation PresentTwoController

- (void)router:(KVRouter *)router getParameter:(NSDictionary *)parameter {
    NSLog(@"%@\n接收参数%@", NSStringFromClass([self class]), parameter);
    self.param = parameter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissbackWithParameter:)]) {
        [self.delegate dismissbackWithParameter:self.param];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
