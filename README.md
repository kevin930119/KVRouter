# KVRouter
详细介绍[请戳此跳转](https://www.jianshu.com/p/bd95af6b8cbc)
# 1 使用KVRouter
## 1.1 注册
KVRouter的运行前提就是页面必须提前注册进KVRouter，KVRouter提供两种方式进行注册。
**1 本地配置文件注册**
该方式能够批量注册页面，方便开发者本身项目已成熟的情况下集成KVRouter降低集成成本（不需要每个页面都去执行一遍注册API），缺点是该种方式注册的页面仅能通过默认方式初始化（init），并且无法添加自己的处理逻辑。
注册信息保存在以下文件，请严格按照该格式输入，也可以查看KVRouter初始化那部分文件解析代码，修改解析规则。
![](https://upload-images.jianshu.io/upload_images/1711666-8051b694659645e5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**2 API注册（比较灵活，可以添加自己的处理逻辑）**
API注册，是我推荐你使用的方式，尽管初步看每个页面都需要写这么一段代码去注册页面，但这确实能够做到页面的充分解耦，例如你删除了这个页面，不需要再去删除配置文件的内容，而且API注册允许你参与到页面的初始化过程来，由你本身来处理页面的初始化，并且可以添加一些业务逻辑。
**说明：在Object-C里面，当类被加载（不是初始化）的时候会触发load方法，KVRouter运用了该特性进行API注册。**
* 简单注册
```
+ (void)load {
    //正常注册，内部使用init进行页面的初始化
    [KVRouter registerUrl:@"pushone" withClass:[self class]];
}
```
* 自定义注册
```
+ (void)load {
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
```
## 1.2 跳转
KVRouter跳转页面支持push和present方式（其实也就这两种方式）。
* push
```
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
```
**PS:iOS的push界面需要一个导航控制器，如果你想使用快速跳转的话需要提前设置KVRouter的全局导航控制器，内部将会使用这个导航控制器进行push跳转，如果不设置，那么KVRouter是不做跳转的，另外，有些App是通过TabbarController来管理多页面的，并且也是通过多个导航控制器来管理，那么每切换一个不同的导航控制器都需要更新KVRouter的导航控制器，这一点在Demo里面有体现**
* present
```
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
```
**PS：快速present操作也需要提前设置来源控制器，一般使用App的根控制器即可，不需要频繁更换，因为present本来就是一种完全沉浸式的用户体验**
## 1.3 获取参数
一般在跳转页面的时候都是需要传值的，KVRouter使用一个很巧妙的设计来实现页面的传值，同样遵循解耦原则。
```
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
```
KVRouter使用了类别来给每个NSObject类都增加了一个方法，当获取到参数的时候会调用该方法传值，我们都知道在Object-C所有类都继承自NSObject，所以只需要在需要接受参数的页面重写该方法就能接受到参数。
接受参数的示例代码如下：
```
- (void)router:(KVRouter *)router getParameter:(NSDictionary *)parameter {
    NSLog(@"%@\n接收参数%@", NSStringFromClass([self class]), parameter);
}
```
# 2 关于Swift版本的介绍
Swift版本的KVRouter仅仅是使用了Swift语言重写，各个方法的命名，实现原理以及使用方法都与Object-C一致，但是由于Swift与Object-C还是存在一些差异，所以Swift版本的KVRouter无法跟OC一样使用API注册方式进行注册页面。
KVRouter的API注册依赖于OC的类**load**方法进行注册，但是Swift不让使用load方法，那么KVRouter基本上是被断了一臂。
![](https://upload-images.jianshu.io/upload_images/1711666-cc98c64cc59f5975.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
但是KVRouter的另一种注册方式还是可用的，就是通过配置文件进行批量注册。
其实只是因为无法在**load**里面注册页面而已，但是KVRouter的注册API还是可以使用，只不过目前我没有找到一种好的时机去注册页面，如果你们找到了，务必联系我，让我也学习一下。
另外一个注意点就是，Swift版本需要提前设置一下项目名称，这是由于Swift命名空间的特性，如果不设置，那么无法动态获取类，也就无法初始化页面了。
```
let projectname = "KVRouter_Swift"; //项目名称（命名空间），不改的话获取不到控制器实例，
```
