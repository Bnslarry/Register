//
//  ForgetPasswordViewController.swift
//  PhoneRegisterSystem
//
//  Created by Lambert Bns on 2017/10/7.
//  Copyright © 2017年 Lambert Bns. All rights reserved.
//

import UIKit
import Alamofire

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var phoneNum: UITextField!
    
    @IBOutlet weak var identifyCode: UITextField!

    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var identifyBtn: UIButton!
    
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var identifyLabel: UILabel!
    
    @IBAction func identify(_ sender: UIButton) {
        identifyLabel.isHidden = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        spinner.isHidden = false
        spinner.startAnimating()
        
        let time: TimeInterval = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            let identCode = self.identifyCode.text
            if(identCode?.characters.count == 4)
            {
                self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
                self.spinner.isHidden = true
                self.identifyLabel.text = "✅"
                self.identifyLabel.isHidden = false
                self.okBtn.isEnabled = true
                self.newPassword.isEnabled = true
                self.identifyCode.isEnabled = false
                self.identifyBtn.isEnabled = false
            }
            else {
                self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
                self.spinner.isHidden = true
                self.identifyLabel.text = "❎"
                self.identifyLabel.isHidden = false
            }
        }
    }
    
    @IBAction func alertPassword(_ sender: UIButton) {
        let urlstring = "http://fengke.net:8081/app/forget"
        Alamofire.request(urlstring, method:.post, parameters: ["userPhone": phoneNum, "userPass": newPassword, "ValidateCode": "9999"]).responseJSON {
            (responds) in
            switch responds.result.isSuccess {
            case true:
                if let value = responds.result.value {
                  let json = JSON(value)
                    if let status = json["status"].int {
                    if(status == 1)
                    {
                        let alert_ok = UIAlertController(title: "提示", message: "修改密码成功!", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert_ok.addAction(okAction)
                        
                        self.present(alert_ok, animated: true, completion: nil)
                    } else {
                        if let code = json["errmsg"]["code"].int {
                            let msg = json["errmsg"]["content"].string
                            
                            switch code{
                            case 105: self.identifyWrong(message: msg)
                            case 1500: self.parameterWrong(message: msg)
                            default : break
                            }
                        }
                    }
                    }
            }
            case false:
                print(responds.result.error!)
            }
        }
    }
    
    @objc func sendButtonClick(_ sender: UIButton) {
        let numString = phoneNum.text
        if(numString?.characters.count != 11)
        {
            let alert_num = UIAlertController(title: "提示", message: "请输入正确的手机号码", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert_num.addAction(okAction)
            
            present(alert_num, animated: true, completion: nil)
        }
        else {
            let urlstring = "http://fengke.net:8081/app/isExist"
            Alamofire.request(urlstring, method:.post, parameters: ["userId": phoneNum!]).responseJSON {
                (returnResult) in
                switch returnResult.result.isSuccess {
                case true:
                    if let value = returnResult.result.value {
                        let json = JSON(value)
                        print(json)
                        if let status = json["status"].int {
                            if(status == 0)
                            {
                                let alert_did = UIAlertController(title: "提示", message: "该用户未注册", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert_did.addAction(okAction)
                                self.present(alert_did, animated: true, completion: nil)
                            }
                            else {
                                self.isCounting = true
                                self.identifyCode.isEnabled = true
                                self.identifyBtn.isEnabled = true
                            }
                        }
                    }
                case false:
                    print(returnResult.result.error!)
                }
            }
        }
        
    }
    
    var sendButton: UIButton!
    
    var countdownTimer: Timer?
    
    var remainingSeconds: Int = 0 {
        willSet {
            sendButton.setTitle("验证码已发送(\(newValue)秒后重新获取)", for: .normal)
            
            if newValue <= 0 {
                sendButton.setTitle("重新获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ForgetPasswordViewController.updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
                
                sendButton.backgroundColor = UIColor.gray
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                sendButton.backgroundColor = UIColor.red
            }
            sendButton.isEnabled = !newValue
        }
    }
    
    func identifyWrong(message msg: String!) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func parameterWrong(message msg: String!) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton = UIButton()
        sendButton.frame = CGRect(x: 40, y: 350, width: view.bounds.width - 80, height: 40)
        sendButton.backgroundColor = UIColor.red
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.setTitle("获取验证码", for: .normal)
        sendButton.addTarget(self, action: #selector(ForgetPasswordViewController.sendButtonClick(_:)), for: .touchUpInside)
        
        self.view.addSubview(sendButton)

        // Do any additional setup after loading the view.
    }

    @objc func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
