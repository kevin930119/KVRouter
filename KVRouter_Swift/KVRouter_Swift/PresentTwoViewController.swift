//
//  PresentTwoViewController.swift
//  KVRouter_Swift
//
//  Created by kevin on 2018/4/4.
//  Copyright © 2018年 kv. All rights reserved.
//

import UIKit

protocol PresentTwoControllerDelegate : NSObjectProtocol {
    func dismissbackWithParameter(parameter : [String:Any]?)
}

class PresentTwoViewController: UIViewController {

    weak var delegate : PresentTwoControllerDelegate?;
    var param : [String:Any]?;
    
    override func router(getParameter parameter: [String : Any]) {
        print("接收参数\(parameter)");
        self.param = parameter;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.delegate != nil {
            self.delegate!.dismissbackWithParameter(parameter: self.param);
        }
        self.dismiss(animated: true, completion: nil);
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
