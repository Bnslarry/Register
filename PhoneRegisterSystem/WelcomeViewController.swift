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
                            if let status = json["status"].int {
                                if(status == 1)
                                {
                                    self.logInSuccess()
                                } else {
                                    if let code = json["errmsg"]["code"].int {
                                        let msg = json["errmsg"]["content"].string
                                        
                                        switch code{
                                        case 101: self.passwordInconsistent(message: msg)
                                        case 102: self.userNotExist(message: msg)
                                        case 1500: self.parameterWrong()
                                        default : break
                                        }
                                    }
                                }
                            }
                        }
                    case false:
                        print(returnResult.result.error!)
                    }
        }
        
    }
    
    func logInSuccess() {
        print("OK!")
    }
    
    func passwordInconsistent(message msg: String!) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func userNotExist(message msg: String!) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func parameterWrong() {
        let alert = UIAlertController(title: "提示", message: "账号或密码不能为空", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
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

