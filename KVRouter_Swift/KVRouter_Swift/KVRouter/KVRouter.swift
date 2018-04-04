//
//  KVRouter.swift
//  KVRouter_Swift
//
//  Created by kevin on 2018/4/3.
//  Copyright © 2018年 kv. All rights reserved.
//

/**
 KVRouter
 项目所有者：Kevin
 联系邮箱：673729631@qq.com
 */

import UIKit

let kvrouter_main_scheme = "kv://";
let projectname = "KVRouter_Swift"; //项目名称（命名空间），不改的话获取不到控制器实例，

typealias KVRouterCreateBlock = ([String:Any]?)->UIViewController?;

class KVRouter {
    lazy var url_interface_map = [:];
    lazy var interface_url_map = [:];
    lazy var url_createBlock_map = [String:KVRouterCreateBlock]();
    
    weak var globalNav : UINavigationController?;
    weak var defaultPresentVC : UIViewController?;
    
    //单例模式
    static let initRouter = KVRouter();
    
    private init() {
        //初始化数据
        let path :String? = Bundle.main.path(forResource: "KVRouterConfigData", ofType: "geojson");
        if path != nil {
            let data : NSData? = NSData.init(contentsOfFile: path!);
            if data != nil {
                let arr = try? JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions(rawValue: 0));
                if arr != nil {
                    let arr1 : Array = arr! as! Array<[String:String]>;
                    for dict in arr1 {
                        let classname = dict["classname"]!;
                        let url = dict["url"]!;
                        self.url_interface_map.updateValue(classname, forKey: url);
                        self.interface_url_map.updateValue(url, forKey: classname);
                    }
                }
            }
        }
    }
    //MARK: - 注册界面
    //Swift4版本不支持load或者initialize类方法，所以无法像OC一样在类加载的时候注册URL，目前还未找到好的解决方法，如何你知道在Swift里面一个更好的时机去注册页面，请务必联系我，不过可以通过配置文件进行页面注册
    @available(*, deprecated, message: "目前无法像OC一样在load或initialize里面注册，如果你找到一个更好的时机去注册页面，务必联系我~~~")
    class func registerUrl(_ url:String, withClass targetClass:AnyClass) {
        self.registerUrl(url, withClass: targetClass, toHandler: nil);
    }
    @available(*, deprecated, message: "目前无法像OC一样在load或initialize里面注册，如果你找到一个更好的时机去注册页面，务必联系我~~~")
    class func registerUrl(_ url:String, withClass targetClass:AnyClass, toHandler handler: KVRouterCreateBlock?) {
        let router = KVRouter.initRouter;
        let newurl = self.getAbsolutepathWithUrl(url);
        if newurl != nil {
            router.url_interface_map.updateValue(NSStringFromClass(targetClass), forKey: newurl!);
            router.interface_url_map.updateValue(newurl!, forKey: NSStringFromClass(targetClass));
            if handler != nil {
                router.url_createBlock_map.updateValue(handler!, forKey: url);
            }
        }
    }
    
    //MARK: - 推荐调用
    class func getObjectWithUrl(_ url:String) -> UIViewController? {
        return self.getObjectWithUrl(url, parameter: nil);
    }
    
    class func getObjectWithUrl(_ url:String, parameter:[String:Any]?) -> UIViewController? {
        let router = KVRouter.initRouter;
        let urlarr = self.handleUrl(url);
        if urlarr == nil {
            return nil;
        }
        let newurl = urlarr!.first!;
        let interfacename = router.url_interface_map[newurl as! String];
        if interfacename == nil {
            return nil;
        }
        let newClassStr : String = interfacename! as! String;
        
        let newClass : AnyClass? = NSClassFromString(projectname+"."+newClassStr);
        if newClass == nil {
            return nil;
        }
        var finalParameter : [String:Any] = [String:Any].init();
        if urlarr!.count == 2 {
            let urlparam = urlarr!.last! as! [String:String];
            for (keyName,valueName) in urlparam{
                finalParameter.updateValue(valueName, forKey: keyName);
            }
        }
        if parameter != nil {
            for (keyName,valueName) in parameter! {
                finalParameter.updateValue(valueName, forKey: keyName);
            }
        }
        
        var vc : UIViewController?;
        let createBlock = router.url_createBlock_map[newurl as! String];
        if createBlock != nil {
            vc = createBlock!(finalParameter);
            if vc == nil {
                return nil;
            }
        }else {
            let viewControllerClass: UIViewController.Type = newClass! as! UIViewController.Type
            vc = viewControllerClass.init();
        }
        
        if finalParameter.count > 0 {
            vc!.router(getParameter: finalParameter);
        }
        
        return vc;
    }
    
    //MARK: - 快速调用
    class func setGlobalNavigationController(_ nav:UINavigationController) {
        let router = KVRouter.initRouter;
        router.globalNav = nav;
    }
    
    class func setDefaultPresentController(_ presentController:UIViewController) {
        let router = KVRouter.initRouter;
        router.defaultPresentVC = presentController;
    }
    
    class func openUrl(_ url:String) -> UIViewController? {
        return self.openUrl(url, parameter: nil);
    }
    
    class func openUrl(_ url:String, parameter:[String:Any]?) -> UIViewController? {
        return self.openUrl(url, parameter: parameter, withNavigationController: nil);
    }
    
    class func openUrl(_ url:String, withNavigationController nav:UINavigationController?) -> UIViewController? {
        return self.openUrl(url, parameter: nil, withNavigationController: nav);
    }
    
    class func openUrl(_ url:String, parameter:[String:Any]?, withNavigationController nav:UINavigationController?) -> UIViewController? {
        let router = KVRouter.initRouter;
        if router.globalNav == nil && nav == nil  {
            return nil;
        }
        if !self.canOpenUrl(url) {
            return nil;
        }
        let vc = self.getObjectWithUrl(url, parameter: parameter);
        if vc != nil {
            if nav != nil {
                nav!.pushViewController(vc!, animated: true);
            }else {
                router.globalNav!.pushViewController(vc!, animated: true);
            }
        }
        return vc;
    }
    
    class func presentUrl(_ url:String) -> UIViewController? {
        return self.presentUrl(url, parameter: nil);
    }
    
    class func presentUrl(_ url:String, parameter:[String:Any]?) -> UIViewController? {
        return self.presentUrl(url, parameter: parameter, sourceViewController: nil);
    }
    
    class func presentUrl(_ url:String, sourceViewController:UIViewController?) -> UIViewController? {
        return self.presentUrl(url, parameter: nil, sourceViewController: sourceViewController);
    }
    
    class func presentUrl(_ url:String, parameter:[String:Any]?, sourceViewController:UIViewController?) -> UIViewController? {
        let router = KVRouter.initRouter;
        if router.defaultPresentVC == nil && sourceViewController == nil {
            return nil;
        }
        if !self.canOpenUrl(url) {
            return nil;
        }
        let vc = self.getObjectWithUrl(url, parameter: parameter);
        if vc != nil {
            if sourceViewController != nil {
                sourceViewController!.present(vc!, animated: true, completion: nil);
            }else {
                router.defaultPresentVC!.present(vc!, animated: true, completion: nil);
            }
        }
        return vc;
    }
    
    //MARK: - 其他
    class func canOpenUrl(_ url:String) -> Bool {
        var flag = false;
        let router = KVRouter.initRouter;
        let aurl = self.getAbsolutepathWithUrl(url);
        if aurl != nil {
            let value = router.url_interface_map[aurl!];
            if value != nil {
                flag = true;
            }
        }
        return flag;
    }
    
    private class func getAbsolutepathWithUrl(_ url:String) -> String? {
        let arr = self.handleUrl(url);
        if arr != nil {
            return arr?.first! as? String;
        }else {
            return nil;
        }
    }
    
    private class func handleUrl(_ url:String) -> [Any]? {
        var urlArr : [Any] = [];
        let newurl = NSMutableString.init(string: url);
        if newurl.hasPrefix(kvrouter_main_scheme) {
            newurl.deleteCharacters(in: NSMakeRange(0, kvrouter_main_scheme.count));
        }
        let componseArr = newurl.components(separatedBy: "?");
        if componseArr.count > 1 {
            urlArr.append(componseArr.first!);
            let parameterStr = componseArr.last!;
            var parameterDict = [String:String]();
            let parametersArr = parameterStr.components(separatedBy: "&");
            for parameter in parametersArr {
                let detailParameters = parameter.components(separatedBy: "=");
                if detailParameters.count == 2 {
                    parameterDict.updateValue(detailParameters.last!, forKey: detailParameters.first!);
                }
            }
            if parameterDict.count > 0 {
                urlArr.append(parameterDict);
            }
        }else {
            urlArr.append(newurl);
        }
        return urlArr;
    }
}

extension UIViewController {
    @objc public func router(getParameter parameter: [String : Any]) {
    }
}
