//
//  GameleyApiHandler.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/12.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

class GameleyApiHandler {
    
    static let shared = GameleyApiHandler()
    
    func getUserInfo(completion: @escaping (_ result: GLUserInfo) -> Void) {
        if LocalStore.isLogin, let userInfo = LocalStore.getObject(key: .userInfo, object: GLUserInfo()) {
            completion(userInfo)
            return
        }
        GameleyNetwork.shared.glRequest(.userInfo) { (resp: GLUserInfoResp) in
            print(resp.toJSON())
            guard let info = resp.info else {
                KRProgressHUD.showError(withMessage: "获取数据失败")
                return
            }
            KRProgressHUD.dismiss()
            completion(info)
        }
    }
    
    func userLoginNormal(account: String, password: String, completion: @escaping (_ result: String) -> Void) {
        GameleyNetwork.shared.glRequest(.loginNormal, method: .post, parameters: ["name": account, "passwd": password.sha1()!], encoding: JSONEncoding.default) { (resp: GLOauthResp) in
            guard resp.state == 0, let info = resp.info else {
                KRProgressHUD.showError(withMessage: resp.msg)
                return
            }

            KRProgressHUD.dismiss()
            completion(info.token!)
        }
    }
    
    func sendPhoneCode(phone: String, completion: @escaping (_ resp: GLBaseResp) -> Void) {
        GameleyNetwork.shared.glRequest(.sendPhoneCode, method: .post, parameters: ["phone": phone]) { (resp: GLBaseResp) in
            completion(resp)
        }
    }
    
    func userLoginPhone(phone: String, code: String, completion: @escaping (_ result: String) -> Void) {
        GameleyNetwork.shared.glRequest(.loginPhone, method: .post, parameters: ["phone": phone, "code": code], encoding: JSONEncoding.default) { (resp: GLOauthResp) in
            guard resp.state == 0, let info = resp.info else {
                KRProgressHUD.showError(withMessage: resp.msg)
                return
            }
            
            KRProgressHUD.dismiss()
            completion(info.token!)
        }
    }
}
