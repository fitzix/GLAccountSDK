//
//  GLBindPhoneViewController.swift
//  GameleySDK
//
//  Created by fitz on 2018/7/27.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLBindPhoneViewController: UIViewController {
    
    var curPhoneNumber: String?
    var newBind = true
    
    var hideCode = "new"
    
    var completion: (() ->Void)?
    
    
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    
    @IBOutlet weak var verifyCodeBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var textFieldCheck: Bool {
        get{
            return phoneField.text?.count == 13 && verifyCodeTextField.text?.count == 4
        }
    }

    var countdownTimer: Timer?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneField.setBottomBorder()
        verifyCodeTextField.setBottomBorder()

        setVerifyLabel()
    }
    
    @objc func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    
    @IBAction func sendVerifyCode(_ sender: UIButton) {
        view.endEditing(true)
        guard let phoneNum = phoneField.text, phoneNum.count == 13 else {
            KRProgressHUD.showError(withMessage: "手机号格式错误")
            return
        }
        var type = 2
        if newBind {
            type = 3
        }
        
        GameleyApiHandler.shared.sendPhoneCodeUpdate(params: ["param": phoneNum.replacingOccurrences(of: "-", with: ""), "type": type]) { [weak self] resp in
            if resp.state != 0 {
                KRProgressHUD.showError(withMessage: resp.msg)
                return
            }
            KRProgressHUD.showSuccess()
            self?.isCounting = true
        }
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
        guard textFieldCheck, let phone = phoneField.text?.replacingOccurrences(of: "-", with: ""), let code = verifyCodeTextField.text else {
            KRProgressHUD.showError(withMessage: "手机号或验证码格式有误")
            return
        }
        var params: Parameters = ["phone": phone, "code": code]
        
        if newBind {
            params["hideCode"] = hideCode
            GameleyNetwork.shared.glRequest(.updatePhone, parameters: params) { [weak self] (resp: GLBaseResp) in
                guard resp.state == 0 else {
                    KRProgressHUD.showError(withMessage: resp.msg)
                    return
                }
                KRProgressHUD.dismiss()
                self?.navigationController?.popViewController(animated: false)
                self?.completion?()
            }
        } else {
            params["hideCode"] = "new"
            GameleyNetwork.shared.glRequest(.changeBindVerify, parameters: ["phone": phone, "code": code], encoding: JSONEncoding.default) { [weak self] (resp: GLUpdateVerifyPhoneResp) in
                guard resp.state == 0, let info = resp.info else {
                    KRProgressHUD.showError(withMessage: resp.msg)
                    return
                }
                KRProgressHUD.dismiss()
                self?.hideCode = info.hideCode
                self?.newBind = true
                self?.setVerifyLabel()
                self?.isCounting = false
            }
        }
    }
    
    func setVerifyLabel() {
        phoneField.text = ""
        verifyCodeTextField.text = ""
        verifyCodeBtn.setTitle("获取验证码", for: .normal)
        
        if newBind {
            warningLabel.text = "验证新的手机号"
            warningLabel.textColor = UIColor(red:1.00, green:0.66, blue:0.06, alpha:1.00)
            nextBtn.setTitle("完成", for: .normal)
            phoneLabel.text = ""
        } else {
            warningLabel.text = "为了保护账号安全\n请先验证当前手机"
            nextBtn.setTitle("下一步", for: .normal)
            phoneLabel.text = curPhoneNumber
        }
    }
}
