//
//  GLLoginModalVC.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/12.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLLoginModalVC: FitzPopUp {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    
    // 快速注册成功view
    @IBOutlet weak var quickRegisterView: UIView!
    @IBOutlet weak var quickAccountLabel: UILabel!
    @IBOutlet weak var quickPasswdLabel: UILabel!
    
    // 注册view
    @IBOutlet weak var registerPhoneField: UITextField!
    @IBOutlet weak var registerCodeField: UITextField!
    @IBOutlet weak var registerSendCodeBtn: UIButton!
    @IBOutlet weak var registerPasswdField: UITextField!
    @IBOutlet weak var registerRepasswdField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    var registerPhoneFieldCheck: Bool {
        get {
            guard let phoneNum = registerPhoneField.text, phoneNum.count == 13 else {
                return false
            }
            return true
        }
    }
    
    var registerCodeFieldCheck: Bool {
        get {
            guard let code = registerCodeField.text, code.count == 4 else {
                return false
            }
            return true
        }
    }
    
    var registerPasswdFieldCheck: Bool {
        get {
            let passwdPattern = "^(?=.*[0-9].*)(?=.*[A-Z].*)(?=.*[a-z].*).{6,16}$"
            
            guard let passwd = registerPasswdField.text, let repasswd = registerRepasswdField.text, GLUtil.GLRegex(passwdPattern).match(input: passwd), passwd == repasswd else {
                return false
            }
            return true
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
            
            registerSendCodeBtn.isEnabled = !newValue
        }
    }
    
    var remainingSeconds = 0 {
        willSet{
            registerSendCodeBtn.setTitle("\(newValue) 秒", for: .normal)
            registerSendCodeBtn.setTitleColor(UIColor(red:0.13, green:0.51, blue:0.97, alpha:1.00), for: .normal)
            if newValue <= 0 {
                registerSendCodeBtn.setTitle("重新获取", for: .normal)
                isCounting = false
            }
        }
    }
    
    // end 注册view
    
    
    @IBOutlet weak var qqLoginBtn: UIButton! {
        didSet{
            if !GameleySDK.shared.registedType[.qq]! {
                qqLoginBtn.isEnabled = false
            }
        }
    }
    @IBOutlet weak var wxLoginBtn: UIButton! {
        didSet{
            if !GameleySDK.shared.registedType[.weChat]! {
                wxLoginBtn.isEnabled = false
            }
        }
    }
    @IBOutlet weak var wbLoginBtn: UIButton! {
        didSet{
            if !GameleySDK.shared.registedType[.weibo]! {
                wbLoginBtn.isEnabled = false
            }
        }
    }
    
    let loginAccountView = GLLoginAccountVC(nibName: "GLLoginAccountVC", bundle: GameleySDK.shared.GLBundle)
    let loginPhoneView = GLLoginPhoneVC(nibName: "GLLoginPhoneVC", bundle: GameleySDK.shared.GLBundle)
    
    
    //    根据第三方初始化信息 判断是否启用第三方登录按钮
    func initOAuthButton(_ btn: UIButton) {
        btn.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.addUnderlineForSelectedSegment()
        // Do any additional setup after loading the view.
        
        addChildViewController(loginPhoneView)
        addChildViewController(loginAccountView)
        
        loginContentView.addSubview(loginPhoneView.view)
        loginContentView.addSubview(loginAccountView.view)
        
        registerPhoneField.setBottomBorder()
        registerCodeField.setBottomBorder()
        registerPasswdField.setBottomBorder()
        registerRepasswdField.setBottomBorder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func removeView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
//    segmented changed
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        segmentControl.segmentedControlValueChanged()
        switch sender.selectedSegmentIndex {
        case 0:
            loginContentView.bringSubview(toFront: loginAccountView.view)
        case 1:
            loginContentView.bringSubview(toFront: loginPhoneView.view)
        default:
            return
        }
    }
    
    
    
//  login action
    
    @IBAction func qqLogin(_ sender: UIButton) {
        MonkeyKing.oauth(for: .qq, scope: "get_user_info") { [weak self] (info, resp, err) in
            guard let unwrappedInfo = info, let token = unwrappedInfo["access_token"] as? String, let openID = unwrappedInfo["openid"] as? String else {
                KRProgressHUD.showError(withMessage: "登录失败")
                return
            }
           
            self?.xLogin(type: .oauthQQ, params: ["accessToken": token, "openId": openID])
        }
    }
    
    @IBAction func wxLogin(_ sender: UIButton) {
        MonkeyKing.oauth(for: .weChat) { [weak self] (dic, resp, err) in
            guard let code = dic?["code"] as? String else {
                KRProgressHUD.showError(withMessage: "登录失败")
                return
            }
            self?.xLogin(type: .oauthWx, params: ["code": code])
        }
        
    }
    
    @IBAction func wbLogin(_ sender: UIButton) {
        MonkeyKing.oauth(for: .weibo) { [weak self] (info, response, error) in
            guard let unwrappedInfo = info, let token = (unwrappedInfo["access_token"] as? String) ?? (unwrappedInfo["accessToken"] as? String), let userID = (unwrappedInfo["uid"] as? String) ?? (unwrappedInfo["userID"] as? String) else {
                KRProgressHUD.showError(withMessage: "登录失败")
                return
            }
            self?.xLogin(type: .oauthWb, params: ["accessToken": token, "uid": userID])
        }
    }
    
    @IBAction func quickLogin(_ sender: UIButton) {
        KRProgressHUD.show()
        //todo 判断是否快速注册过
        GameleyNetwork.shared.glRequest(.quickRegister, parameters: [:], addMask: false) { [weak self] (resp: GLQuickRegisterResp) in
            guard resp.state == 0, let info = resp.info else {
                KRProgressHUD.showError(withMessage: resp.msg)
                return
            }
            
            guard let `self` = self else { return }
            
            self.contentView.bringSubview(toFront:self.quickRegisterView)
            self.quickAccountLabel.text = info.account
            self.quickPasswdLabel.text = info.passwd
            LocalStore.save(key: .userToken, info: info.token)
            
            if let quickInfoImg = self.getQuickInfoImg() {
                UIImageWriteToSavedPhotosAlbum(quickInfoImg, nil, nil, nil)
                KRProgressHUD.showInfo(withMessage: "账号信息已保存到相册")
                return
            }
            KRProgressHUD.dismiss()
        }
    }
    
    func xLogin(type: GLConfig.GLRequestURL, params: [String: Any]) {
        GameleyNetwork.shared.glRequest(type, parameters: params) { [weak self] (resp: GLOauthResp) in
            guard let info = resp.info, let token = info.token else {
                KRProgressHUD.showError(withMessage: "获取数据失败")
                return
            }
            KRProgressHUD.dismiss()
            
            LocalStore.save(key: .userToken, info: token)
            
            GameleyApiHandler.shared.getUserInfo{ userInfo in
                self?.dismiss(animated: false, completion: nil)
                GameleySDK.shared.didLogin(userInfo: userInfo)
            }
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        KRProgressHUD.showOn(self).show()
        GameleyApiHandler.shared.getUserInfo(addMask: false) { [weak self] userInfo in
            self?.dismiss(animated: false, completion: nil)
            GameleySDK.shared.didLogin(userInfo: userInfo)
        }
    }
    
    // 保存为UIImage
    open func getQuickInfoImg() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(quickRegisterView.bounds.size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        quickRegisterView.layer.render(in: context)
        let quickInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return quickInfo
    }
    
    //------------------------------手机注册--------------------------------
    @objc func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    @IBAction func removePhoneRegisterView(_ sender: UIButton) {
        contentView.bringSubview(toFront: loginView)
    }
    
    @IBAction func getVerifyCode(_ sender: UIButton) {
        view.endEditing(true)
        guard registerPhoneFieldCheck else {
            KRProgressHUD.showError(withMessage: "手机号格式错误")
            return
        }
        GameleyApiHandler.shared.sendPhoneCode(params: ["phone": phoneNum.replacingOccurrences(of: "-", with: "")]) { [weak self] resp in
            if resp.state != 0 {
                KRProgressHUD.showError(withMessage: resp.msg)
                self?.remainingSeconds = -1
                return
            }
            KRProgressHUD.showSuccess()
            self?.isCounting = true
        }
    }
    
    //---------------------------------------------------------------------
}
