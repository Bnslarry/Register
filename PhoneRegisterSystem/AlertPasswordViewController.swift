//
//  AlertPasswordViewController.swift
//  PhoneRegisterSystem
//
//  Created by Lambert Bns on 2017/10/7.
//  Copyright © 2017年 Lambert Bns. All rights reserved.
//

import UIKit
import Alamofire

class AlertPasswordViewController: UIViewController {

    
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var reconfigureBtn: UIButton!
    
    @IBAction func reconfigure(_ sender: UIButton) {
        let phoneNum = userPhone.text
        let pass = password.text
        let newPass = newPassword.text
        
        if(phoneNum?.characters.count == 0 || pass?.characters.count == 0 || newPass?.characters.count == 0) {
            let alert = UIAlertController(title: "提示", message: "请正确填写手机号和密码", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            var msg = ""
            let urlstring = "http://fengke.net:8081/app/changePass"
            Alamofire.request(urlstring, method:.post, parameters: ["userPhone": phoneNum!, "userPass": pass!, "NewUserPass": newPass!]).responseJSON {
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
        }
        
    }
    
    func showMessage(message msg: String!) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
