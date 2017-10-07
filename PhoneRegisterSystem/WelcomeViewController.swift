//
//  ViewController.swift
//  PhoneRegisterSystem
//
//  Created by Lambert Bns on 2017/10/3.
//  Copyright © 2017年 Lambert Bns. All rights reserved.
//

import UIKit
import Alamofire

class WelcomeViewController: UIViewController {
    
    

    @IBOutlet weak var phoneNum: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func logIn(_ sender: UIButton) {
        
        let urlstring = "http://fengke.net:8081/app/login"
        
        Alamofire.request(urlstring, method:.post, parameters: ["userPhone": phoneNum.text!, "userPass": password.text!]).responseJSON {
            (returnResult) in
           // print("POST_Request --> post 请求 --> returnResult = \(returnResult)")

            switch returnResult.result.isSuccess {
            case true:
                if let value = returnResult.result.value {
                   let json = JSON(value)
                    print(json)
                    if let code = json["errmsg"]["content"].string {
                        print("code: \(code)")
                    }
                }
            case false:
                print(returnResult.result.error!)
            }
            
        }
            
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

