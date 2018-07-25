//
//  GLLoginPhoneVC.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/11.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import KRProgressHUD

class GLLoginPhoneVC: UIViewController {

    @IBOutlet weak var loginPhone: UITextField!
    @IBOutlet weak var loginCode: UITextField!
    @IBOutlet weak var verifyCodeBtn: UIButton!
    
    var textFieldCheck: Bool {
        get{
            return loginPhone.text?.count == 13 && loginCode.text?.count == 4
        }
    }
    
    var countdownTimer: Timer?
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(timer:)), userInfo: nil, repeats: true)
                remainingSeconds = 60
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
            
            verifyCodeBtn.isEnabled = !newValue
        }
    }

    var remainingSeconds = 0 {
        willSet{
            verifyCodeBtn.setTitle("\(newValue) 秒", for: .normal)
            verifyCodeBtn.setTitleColor(UIColor(red:0.13, green:0.51, blue:0.97, alpha:1.00), for: .normal)
            if newValue <= 0 {
                verifyCodeBtn.setTitle("重新获取", for: .normal)
                isCounting = false
            }
        }
    }
    
    @objc func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPhone.setBottomBorder()
        loginCode.setBottomBorder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getVerifyCode(_ sender: UIButton) {
        view.endEditing(true)
        guard let phoneNum = loginPhone.text, phoneNum.count == 13 else {
            KRProgressHUD.showError(withMessage: "手机号格式错误")
            return
        }
        GameleyApiHandler.shared.sendPhoneCode(phone: phoneNum.replacingOccurrences(of: "-", with: "")) { [weak self] resp in
            if resp.state != 0 {
                KRProgressHUD.showError(withMessage: resp.msg)
                self?.remainingSeconds = -1
            }
            KRProgressHUD.showSuccess()
            self?.isCounting = true
        }
    }
    
    @IBAction func loginByPhoneCode(_ sender: UIButton) {
        view.endEditing(true)
        guard textFieldCheck, let phone = loginPhone.text?.replacingOccurrences(of: "-", with: ""), let code = loginCode.text else {
            KRProgressHUD.showError(withMessage: "验证码格式有误")
            return
        }
        if textFieldCheck {
            GameleyApiHandler.shared.userLoginPhone(phone: phone, code: code) { token in
                LocalStore.save(key: .userToken, info: token)
                
                GameleyApiHandler.shared.getUserInfo{ userInfo in
                    self.dismiss(animated: false, completion: nil)
                    GameleySDK.shared.didLogin(userInfo: userInfo)
                }
            }
        }
    }
    
}
