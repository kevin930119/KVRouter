//
//  AppDelegate.m
//  KVRouterDemo
//
//  Created by kevin on 2018/4/2.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNavigationViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    OneViewController * vc = [[OneViewController alloc] init];
    vc.title = @"push形式";
    CustomNavigationViewController * nav = [[CustomNavigationViewController alloc] initWithRootViewController:vc];
    //如果不使用快速调用的相关API，这里可以不调用
    //默认选中第一个，设置全局导航控制器
    [KVRouter setGlobalNavigationController:nav];
    
    TwoViewController * vc1 = [[TwoViewController alloc] init];
    vc1.title = @"present形式";
    CustomNavigationViewController * nav1 = [[CustomNavigationViewController alloc] initWithRootViewController:vc1];
    
    UITabBarController * tabVC = [[UITabBarController alloc] init];
    tabVC.view.backgroundColor = [UIColor whiteColor];
    tabVC.delegate = self;
    tabVC.viewControllers = @[nav, nav1];
    
    self.window.rootViewController = tabVC;
    //如果不使用快速调用的相关API，这里可以不调用
    //设置默认弹出来源控制器
    [KVRouter setDefaultPresentController:tabVC];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //如果不使用快速调用的相关API，这里可以不调用
    //更新全局的导航控制器，因为这里的tabbar分别使用不同的导航控制器进行子控制器的管理，所以需要在切换的时候更新
    [KVRouter setGlobalNavigationController:(UINavigationController*)viewController];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
