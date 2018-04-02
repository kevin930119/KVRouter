//
//  KVRouter.h
//  KVRouterDemo
//
//  Created by kevin on 2018/4/2.
//  Copyright © 2018年 kv. All rights reserved.
//
/**
 该路由器可以做到项目界面间的充分解耦，不需要像传统做法一样在推出下个界面前需要引入下个界面的头文件，使用该路由器，除非一些必须的耦合（例如使用协议代理），不然不用引入头文件，提供了各种API，灵活度比较高，方便开发，后续将会继续完善，谢谢支持。
 备注：使用该路由器的成本比较高，如果你的项目已经成型，那么需要修改的地方比较多，例如之前的push和present方式都需要修改，注册页面也需要一个个注册，所以KVRouter提供了一个统一注册配置的json文件，可以在这个json文件进行统一注册，降低集成成本。
 */

/**
 说明：跳转链接可识别scheme以及链接携带的参数，参数同样会通过方法回调
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kvrouter_main_scheme @"kv://"   //项目的协议名称，例如你的项目属于开放性App，可以通过deeplink唤起，其他App可以通过 kv://one 链接打开你的页面，那么路由器会截取掉scheme进行路径匹配

/**
 自定义的界面创建回调，用于某些特殊界面的创建方式不是内部默认的init
 
 @param parameter 传参，如果没有参数，那么传的是nil
 @return 返回一个界面实例，可以自定义创建方法，也可以对界面实例进行初步赋值等操作，如果返回的是nil，那么将不会跳转，可用于某些界面需要用户登录后才能跳转的判定
 */
typedef UIViewController*(^KVRouterCreateBlock)(NSDictionary * parameter);

@interface KVRouter : NSObject

/**
 初始化路由器

 @return 返回实例
 */
+ (instancetype)initRouter;

#pragma mark - 注册界面

/**
 注册自定义界面，默认使用init方式创建
 
 @param url 链接url
 */
+ (void)registerUrl:(NSString *)url withClass:(Class)targetClass;

/**
 注册自定义的界面创建方法，用于某些界面的创建不是通过init的方法进行创建的情况，例如tableViewController等
 
 @param url 链接url
 @param handler 创建回调block，返回一个创建好的页面实例
 */
+ (void)registerUrl:(NSString*)url withClass:(Class)targetClass toHandler:(KVRouterCreateBlock)handler;

#pragma mark - 推荐调用

/**
 通过url获取一个控制器实例，如果找不到控制器实例，那么返回nil
 
 @param url 链接url
 @return 返回控制器实例
 */
+ (UIViewController*)getObjectWithUrl:(NSString*)url;

/**
 通过url获取一个控制器实例，可以传参，如果找不到控制器实例，那么返回nil
 
 @param url 链接url
 @param parameter 传递的参数
 @return 返回控制器实例
 */
+ (UIViewController*)getObjectWithUrl:(NSString *)url parameter:(NSDictionary*)parameter;

#pragma mark - 快速调用

/**
 设置全局导航栏，用于快速push时使用
 当你的项目中是使用多个导航控制器管理页面时，需要根据需要在适当的时机设置push的导航控制器（例如使用Tabbar管理多页面并且使用多个导航控制器分别管理，那么在点击Tabbar切换页面时，需要更新一下push用的导航控制器）

 @param nav 导航栏
 */
+ (void)setGlobalNavigationController:(UINavigationController*)nav;

/**
 设置默认弹出控制器，用于快速present时使用
 由于present方式弹出控制器属于完全沉浸式的用户体验，所以这里建议统一由AppDelegate的RootViewController进行present，不需要频繁更换

 @param presentController 弹出控制器
 */
+ (void)setDefaultPresentController:(UIViewController*)presentController;

/**
 快速跳转页面push

 @param url 跳转链接
 @return 页面实例
 */
+ (UIViewController*)openUrl:(NSString*)url;

/**
 快速跳转页面push，可携带参数

 @param url 跳转链接
 @param parameter 参数
 @return 页面实例
 */
+ (UIViewController*)openUrl:(NSString*)url parameter:(NSDictionary*)parameter;

/**
 快速跳转页面push

 @param url 跳转链接
 @param nav 导航控制器
 @return 页面实例
 */
+ (UIViewController*)openUrl:(NSString *)url withNavigationController:(UINavigationController*)nav;

/**
 快速跳转页面push，可携带参数

 @param url 跳转链接
 @param parameter 参数
 @param nav 导航控制器
 @return 页面实例
 */
+ (UIViewController*)openUrl:(NSString*)url parameter:(NSDictionary*)parameter withNavigationController:(UINavigationController*)nav;

/**
 快速弹出页面present

 @param url 跳转链接
 @return 页面实例
 */
+ (UIViewController*)presentUrl:(NSString*)url;

/**
 快速弹出页面present，可携带参数

 @param url 跳转链接
 @param parameter 参数
 @return 页面实例
 */
+ (UIViewController*)presentUrl:(NSString *)url parameter:(NSDictionary*)parameter;

/**
 快速弹出页面present

 @param url 跳转链接
 @param sourceViewController 来源控制器，用于弹出
 @return 页面实例
 */
+ (UIViewController*)presentUrl:(NSString *)url sourceViewController:(UIViewController*)sourceViewController;

/**
 快速弹出页面present，可携带参数

 @param url 跳转链接
 @param parameter 参数
 @param sourceViewController 来源控制器，用于弹出
 @return 页面实例
 */
+ (UIViewController*)presentUrl:(NSString *)url parameter:(NSDictionary*)parameter sourceViewController:(UIViewController*)sourceViewController;

#pragma mark - 其他

/**
 是否可以跳转该url
 
 @param url 链接url
 @return 返回布尔值
 */
+ (BOOL)canOpenUrl:(NSString*)url;

/**
 通过类获取对应的链接url
 
 @param targetClass 想要查询的class
 @return 返回链接url，没有则返回nil
 */
+ (NSString*)getUrlWithClass:(Class)targetClass;

/**
 通过类名获取对应的链接url
 
 @param className 想要查询的类的名
 @return 返回链接url，没有则返回nil
 */
+ (NSString*)getUrlWithClassName:(NSString*)className;

@end

@interface NSObject (KVRouter)

/**
 发送参数

 @param parameter 参数
 */
- (void)routerSendParameter:(NSDictionary *)parameter;

/**
 用于传参的分类方法
 使用方法：
 在控制器内部重写这个方法，如果有传参，那么会调用这个方法
 
 @param router 路由器
 @param parameter 传递的参数
 */
- (void)router:(KVRouter *)router getParameter:(NSDictionary *)parameter;

@end



