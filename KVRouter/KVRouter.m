//
//  KVRouter.m
//  KVRouterDemo
//
//  Created by kevin on 2018/4/2.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "KVRouter.h"

@interface KVRouter ()

@property (nonatomic, strong) NSMutableDictionary * url_interface_map; //url与界面名称的映射字典
@property (nonatomic, strong) NSMutableDictionary * interface_url_map;  //界面名称与url的映射字典，用于快速通过界面名称查找到对应的url
@property (nonatomic, strong) NSMutableDictionary * url_createBlock_map;    //url与界面创建block的映射字典，用于自定义界面的创建，而不使用内部默认的init

@property (nonatomic, weak) UINavigationController * globalNav;
@property (nonatomic, weak) UIViewController * defaultPresentVC;

@end

@implementation KVRouter

+ (instancetype)initRouter {
    static KVRouter * kvrouter = nil;
    static dispatch_once_t kvroutertoken;
    dispatch_once(&kvroutertoken, ^{
        kvrouter = [[self alloc] init];
    });
    return kvrouter;
}

- (instancetype)init {
    if (self = [super init]) {
        self.url_interface_map = [NSMutableDictionary dictionary];
        self.interface_url_map = [NSMutableDictionary dictionary];
        self.url_createBlock_map = [NSMutableDictionary dictionary];
        //读取本地配置数据
        NSString * path = [[NSBundle mainBundle] pathForResource:@"KVRouterConfigData" ofType:@"geojson"];
        if (path.length) {
            NSData * data = [NSData dataWithContentsOfFile:path];
            if (data) {
                NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (arr.count) {
                    for (NSDictionary * url_map in arr) {
                        [self.url_interface_map setObject:url_map[@"classname"] forKey:url_map[@"url"]];
                        [self.interface_url_map setObject:url_map[@"url"] forKey:url_map[@"classname"]];
                    }
                }
            }
        }
    }
    return self;
}

#pragma mark - 注册界面
+ (void)registerUrl:(NSString *)url withClass:(Class)targetClass {
    [self registerUrl:url withClass:targetClass toHandler:nil];
}

+ (void)registerUrl:(NSString*)url withClass:(Class)targetClass toHandler:(KVRouterCreateBlock)handler {
    KVRouter * router = [KVRouter initRouter];
    NSString * newurl = [self getAbsolutepathWithUrl:url];
    if (newurl) {
        [router.url_interface_map setObject:NSStringFromClass(targetClass) forKey:newurl];
        [router.interface_url_map setObject:newurl forKey:NSStringFromClass(targetClass)];
        if (handler) {
            [router.url_createBlock_map setObject:handler forKey:newurl];
        }
    }
}

#pragma mark - 推荐调用
+ (UIViewController *)getObjectWithUrl:(NSString *)url {
    return [self getObjectWithUrl:url parameter:nil];
}

+ (UIViewController *)getObjectWithUrl:(NSString *)url parameter:(NSDictionary *)parameter {
    KVRouter * router = [KVRouter initRouter];
    //处理url
    NSArray * urlarr = [self handleUrl:url];
    if (!urlarr) {
        return nil;
    }
    NSString * newurl = urlarr.firstObject;
    //先获取有没有注册过界面
    NSString * interfacename = [router.url_interface_map objectForKey:newurl];
    Class newClass = NSClassFromString(interfacename);
    if (!newClass) {
        return nil;
    }
    UIViewController * vc = nil;
    KVRouterCreateBlock createBlock = [router.url_createBlock_map objectForKey:newurl];
    if (createBlock) {
        vc = createBlock(parameter); //调用注册的自定义创建界面的回调
        if (!vc) {
            return nil; //如果没有，那么直接返回
        }
    }else {
        vc = [[newClass alloc] init];
    }
    //处理参数
    NSMutableDictionary * finalParameter = nil;
    if (urlarr.count == 2) {
        finalParameter = [NSMutableDictionary dictionaryWithDictionary:urlarr.lastObject];
    }
    if (parameter) {
        if (finalParameter) {
            //链接携带参数
            for (NSString * key in parameter.allKeys) {
                [finalParameter setObject:parameter[key] forKey:key];
            }
        }else {
            finalParameter = [NSMutableDictionary dictionaryWithDictionary:parameter];
        }
    }
    if (finalParameter) {
        //传参
        [vc router:router getParameter:finalParameter];
    }
    return vc;
}

#pragma mark - 快速调用
+ (void)setGlobalNavigationController:(UINavigationController *)nav {
    KVRouter * router = [KVRouter initRouter];
    router.globalNav = nav;
}

+ (void)setDefaultPresentController:(UIViewController *)presentController {
    KVRouter * router = [KVRouter initRouter];
    router.defaultPresentVC = presentController;
}

+ (UIViewController *)openUrl:(NSString *)url {
    return [self openUrl:url parameter:nil];
}

+ (UIViewController*)openUrl:(NSString*)url parameter:(NSDictionary*)parameter {
    return [self openUrl:url parameter:parameter withNavigationController:nil];
}

+ (UIViewController*)openUrl:(NSString *)url withNavigationController:(UINavigationController*)nav {
    return [self openUrl:url parameter:nil withNavigationController:nav];
}

+ (UIViewController*)openUrl:(NSString*)url parameter:(NSDictionary*)parameter withNavigationController:(UINavigationController*)nav {
    KVRouter * router = [KVRouter initRouter];
    if (!router.globalNav && !nav) {
        return nil;
    }
    if (![self canOpenUrl:url]) {
        return nil;
    }
    UIViewController * vc = [self getObjectWithUrl:url parameter:parameter];
    if (!vc) {
        return nil;
    }
    if (nav) {
        [nav pushViewController:vc animated:YES];
    }else {
        [router.globalNav pushViewController:vc animated:YES];
    }
    return vc;
}

+ (UIViewController*)presentUrl:(NSString*)url {
    return [self presentUrl:url parameter:nil];
}

+ (UIViewController*)presentUrl:(NSString *)url parameter:(NSDictionary*)parameter {
    return [self presentUrl:url parameter:parameter sourceViewController:nil];
}

+ (UIViewController*)presentUrl:(NSString *)url sourceViewController:(UIViewController*)sourceViewController {
    return [self presentUrl:url parameter:nil sourceViewController:sourceViewController];
}

+ (UIViewController*)presentUrl:(NSString *)url parameter:(NSDictionary*)parameter sourceViewController:(UIViewController*)sourceViewController {
    KVRouter * router = [KVRouter initRouter];
    if (!router.defaultPresentVC && !sourceViewController) {
        return nil;
    }
    if (![self canOpenUrl:url]) {
        return nil;
    }
    UIViewController * vc = [self getObjectWithUrl:url parameter:parameter];
    if (!vc) {
        return nil;
    }
    if (sourceViewController) {
        [sourceViewController presentViewController:vc animated:YES completion:nil];
    }else {
        [router.defaultPresentVC presentViewController:vc animated:YES completion:nil];
    }
    return vc;
}


#pragma mark - 其他
+ (BOOL)canOpenUrl:(NSString*)url {
    KVRouter * router = [KVRouter initRouter];
    NSString * className = [router.url_interface_map objectForKey:[self getAbsolutepathWithUrl:url]];
    if (className) {
        return YES;
    }else {
        return NO;
    }
}

+ (NSString*)getUrlWithClass:(Class)targetClass {
    return [self getUrlWithClassName:NSStringFromClass(targetClass)];
}

+ (NSString*)getUrlWithClassName:(NSString*)className {
    KVRouter * router = [KVRouter initRouter];
    if ([className isKindOfClass:[NSString class]]) {
        return [router.interface_url_map objectForKey:className];
    }else {
        return nil;
    }
}

+ (NSString*)getAbsolutepathWithUrl:(NSString*)url {
    return [self handleUrl:url].firstObject;
}

+ (NSArray*)handleUrl:(NSString*)url {
    if (![url isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSMutableArray * urlArr = [NSMutableArray array];
    NSMutableString * newurl = [NSMutableString stringWithString:url];
    //分割协议
    if ([newurl hasPrefix:kvrouter_main_scheme]) {
        //需要去除协议名称
        [newurl deleteCharactersInRange:NSMakeRange(0, kvrouter_main_scheme.length)];
    }
    NSArray * componseArr = [newurl componentsSeparatedByString:@"?"];
    if (componseArr.count > 1) {
        [urlArr addObject:componseArr.firstObject];
        //处理参数
        NSString * parameterStr = componseArr.lastObject;
        //继续切割
        NSMutableDictionary * parameterDict = [NSMutableDictionary dictionary];
        NSArray * parametersArr = [parameterStr componentsSeparatedByString:@"&"];
        for (NSString * parameter in parametersArr) {
            //使用等号切割
            NSArray * detailParameters = [parameter componentsSeparatedByString:@"="];
            if (detailParameters.count == 2) {
                [parameterDict setObject:detailParameters.lastObject forKey:detailParameters.firstObject];
            }
        }
        if (parameterDict.count) {
            [urlArr addObject:parameterDict];
        }
    }else {
        [urlArr addObject:newurl];
    }
    return urlArr;
}

@end

@implementation NSObject (KVRouter)

- (void)routerSendParameter:(NSDictionary *)parameter {
    [self router:nil getParameter:parameter];
}

- (void)router:(KVRouter *)router getParameter:(NSDictionary *)parameter {
    
}

@end
