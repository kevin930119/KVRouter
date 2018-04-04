//
//  OneViewController.swift
//  KVRouter_Swift
//
//  Created by kevin on 2018/4/3.
//  Copyright © 2018年 kv. All rights reserved.
//

import UIKit

class OneViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red;
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = KVRouter.getObjectWithUrl("pushone?id=1");
        if vc != nil {
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        //以下为快速push，需要提前设置全局导航控制器
//        if KVRouter.openUrl("pushone") == nil {
//            print("没有该路径");
//        }
        //携带参数
//        if KVRouter.openUrl("pushone?id=1") == nil {
//            print("没有该路径");
//        }
        //携带多参数
//        if KVRouter.openUrl("pushone?id=1", parameter: ["user" : "kevin"]) == nil {
//            print("没有该路径");
//        }
        //传入导航控制器进行跳转
//        if KVRouter.openUrl("pushone", withNavigationController: self.navigationController) == nil {
//            print("没有该路径");
//        }
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
