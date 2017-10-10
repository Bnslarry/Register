//
//  File.swift
//  PhoneRegisterSystem
//
//  Created by Lambert Bns on 2017/10/7.
//  Copyright © 2017年 Lambert Bns. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SendMessageViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var identifiedCode: UITextField!
    @IBOutlet weak var identityLabel: UILabel!
    
    @IBOutlet weak var identityBtn: UIButton!
    @IBOutlet weak var NextBtn: UIButton!
    @IBAction func identity(_ sender: UIButton) {
        
        identityLabel.isHidden = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        spinner.isHidden = false
        spinner.startAnimating()
        
        let time: TimeInterval = 0.6
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            let identCode = self.identifiedCode.text
            if(identCode?.characters.count == 4)
            {
                self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
                self.spinner.isHidden = true
                self.identityLabel.text = "✅"
                self.identityLabel.isHidden = false
                self.NextBtn.isEnabled = true
                self.identityBtn.isEnabled = false
                self.identifiedCode.isEnabled = false
            }
            else {
                self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
                self.spinner.isHidden = true
                self.identityLabel.text = "❎"
                self.identityLabel.isHidden = false
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
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SendMessageViewController.updateTime(_:)), userInfo: nil, repeats: true)
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editInfoSegue") {
            let controller = segue.destination as! EditInfoViewController
            
            controller.userPhone = phone.text!
            print("手机号:\(controller.userPhone)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton = UIButton()
        sendButton.frame = CGRect(x: 40, y: 380, width: view.bounds.width - 80, height: 40)
        sendButton.backgroundColor = UIColor.red
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.setTitle("获取验证码", for: .normal)
        sendButton.addTarget(self, action: #selector(SendMessageViewController.sendButtonClick(_:)), for: .touchUpInside)
        
        self.view.addSubview(sendButton)
    }
    
    @objc func sendButtonClick(_ sender: UIButton) {
        let numString = phone.text
        if(numString?.characters.count != 11)
        {
            let alert_num = UIAlertController(title: "提示", message: "请输入正确的手机号码", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert_num.addAction(okAction)
            
            present(alert_num, animated: true, completion: nil)
        }
        else {
            let urlstring = "http://fengke.net:8081/app/isExist"
            Alamofire.request(urlstring, method:.post, parameters: ["userId": numString!]).responseJSON {
                (returnResult) in
                switch returnResult.result.isSuccess {
                case true:
                    if let value = returnResult.result.value {
                        let json = JSON(value)
                        print(json)
                        if let status = json["status"].int {
                            if(status == 1)
                            {
                                let alert_did = UIAlertController(title: "提示", message: "该用户已注册", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert_did.addAction(okAction)
                                self.present(alert_did, animated: true, completion: nil)
                            }
                            else {
                                let url = "http://fengke.net:8081/app/message"
                                Alamofire.request(url, method:.post, parameters: ["userPhone": self.phone.text!]).responseJSON {
                                    (returnResult) in
                                }
                                self.isCounting = true
                                self.identifiedCode.isEnabled = true
                                self.identityBtn.isEnabled = true
                            }
                        }
                    }
                case false:
                    print(returnResult.result.error!)
                }
            }
        }
        
    }
    
    @objc func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

