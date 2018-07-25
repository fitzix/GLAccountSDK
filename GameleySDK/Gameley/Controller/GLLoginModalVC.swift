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
        
        contentView.addSubview(loginPhoneView.view)
        contentView.addSubview(loginAccountView.view)
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
            contentView.bringSubview(toFront: loginAccountView.view)
        case 1:
            contentView.bringSubview(toFront: loginPhoneView.view)
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
    
    func xLogin(type: GameleyNetwork.GLRequestURL, params: [String: Any]) {
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
}
