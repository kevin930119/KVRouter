//
//  TwoViewController.swift
//  KVRouter_Swift
//
//  Created by kevin on 2018/4/4.
//  Copyright © 2018年 kv. All rights reserved.
//

import UIKit

class TwoViewController: UIViewController, PresentTwoControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue;
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //这个页面是通过配置文件进行注册的，仅能通过init方法初始化
        //如果需要在该控制器在包装一层导航栏，可以获取到该控制器实例后再自行包装
//        let vc = KVRouter.getObjectWithUrl("presenttwo");
//        if vc != nil {
//            self.present(vc!, animated: true, completion: nil);
//        }
        //快速present
//        if KVRouter.presentUrl("presenttwo") == nil {
//            print("没有该路径");
//        }
        //携带参数
//        if KVRouter.openUrl("presenttwo?id=1") == nil {
//            print("没有该路径");
//        }
        //携带多参数，设置代理，协议代理是一种强耦合关系，无法取消
        let vc = KVRouter.presentUrl("presenttwo?id=1", parameter: ["user" : "kevin"]);
        if vc != nil {
            let vc1 = vc! as! PresentTwoViewController;
            vc1.delegate = self;
        }else {
            print("没有该路径");
        }
        //传入来源控制器进行present
//        if KVRouter.presentUrl("presenttwo", sourceViewController: self) == nil {
//            print("没有该路径");
//        }
    }
    
    func dismissbackWithParameter(parameter: [String : Any]?) {
        print("协议代理回调");
        if parameter != nil {
            print("\(parameter!)");
        }
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
