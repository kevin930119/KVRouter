//
//  PushOneViewController.swift
//  KVRouter_Swift
//
//  Created by kevin on 2018/4/4.
//  Copyright © 2018年 kv. All rights reserved.
//

import UIKit

class PushOneViewController: UIViewController {
    //在OC中是在以下两个方法中注册页面，可惜，swift并不支持这两个方法，如果你知道一个更好的时机去注册页面，务必联系我
//    override class func load() {
//        KVRouter.registerUrl("pushone", withClass: PushOneViewController.self);
//        KVRouter.registerUrl("pushone", withClass: PushOneViewController.self) { (param) -> UIViewController? in
//            return nil;
//        };
//    }
//    override class func initialize() {
//
//    }
    
    override func router(getParameter parameter: [String : Any]) {
        print("接收参数\(parameter)");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
