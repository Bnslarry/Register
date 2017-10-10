//
//  EditInfoViewController.swift
//  PhoneRegisterSystem
//
//  Created by Lambert Bns on 2017/10/7.
//  Copyright © 2017年 Lambert Bns. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class EditInfoViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var passwordAgain: UITextField!
    
    @IBAction func register(_ sender: UIButton) {
        if(Validate.username(userName.text).isRight && Validate.password(password.text).isRight &&  Validate.email(email.text).isRight && password.text == passwordAgain.text)
        {
            var msg = ""
            let urlstring = "http://fengke.net:8081/app/reg"
            
            Alamofire.request(urlstring, method:.post, parameters: ["userPhone": userPhone, "userPass": password.text!, "userName": userName.text!, "userEmail": email.text!]).responseJSON {
                (returnResult) in
                switch returnResult.result.isSuccess {
                case true:
                    if let value = returnResult.result.value {
                        let json = JSON(value)
                        if let status = json["status"].int {
                            if(status == 1)
                            {
                                msg = json["content"].string!
                            }
                            else {
                                msg = json["errmsg"]["content"].string!
                            }
                        }
                        self.showMessage(message: msg)
                    }
                case false:
                    print(returnResult.result.error!)
                }
            }
        } else {
            let alert = UIAlertController(title: "提示", message: "请正确填写各项信息", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
        userName.resignFirstResponder()
        password.resignFirstResponder()
        passwordAgain.resignFirstResponder()
        email.resignFirstResponder()
    }
    var userPhone = ""
    
    enum Validate {
        case email(_: String?)
        case username(_: String?)
        case password(_: String?)

        var isRight: Bool {
            var predicateStr:String!
            var currObject:String!
            switch self {
            case let .email(str):
                predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                currObject = str
            case let .username(str):
                predicateStr = "^[A-Za-z0-9]{2,20}+$"
                currObject = str
            case let .password(str):
                predicateStr = "^[a-zA-Z0-9]{6,20}+$"
                currObject = str
            }
            let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
            
            return predicate.evaluate(with: currObject)
            
        }
        
    }
    
    func showMessage(message msg: String!) {
        if(msg == "注册成功!")
        {
            let alert_ok = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in self.performSegue(withIdentifier: "RegisterOKCome", sender: nil)
            })
            alert_ok.addAction(okAction)
            self.present(alert_ok, animated: true, completion: nil)
        }
        else {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
