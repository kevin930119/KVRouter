//
//  ViewController.swift
//  KVRouter_Swift
//
//  Created by kevin on 2018/4/3.
//  Copyright © 2018年 kv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var viewisappear = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.viewisappear {
//            let vc = KVRouter.getObjectWithUrl("one?a=1");
//            if vc != nil {
//                self.present(vc!, animated: true, completion: nil);
//            }
            KVRouter.setDefaultPresentController(self);
//            KVRouter.presentUrl("one?a=1");
            if KVRouter.presentUrl("one?a=1", sourceViewController: self) == nil {
                print("找不到这个页面");
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewisappear = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewisappear = false;
    }
    
    
}
