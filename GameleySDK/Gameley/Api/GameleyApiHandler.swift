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
        GameleyNetwork.shared.glRequest(.loginNormal, parameters: ["name": account, "passwd": password.sha1()!], encoding: JSONEncoding.default) { (resp: GLOauthResp) in
            guard resp.state == 0, let info = resp.info else {
                KRProgressHUD.showError(withMessage: resp.msg)
                return
            }

            KRProgressHUD.dismiss()
            completion(info.token!)
        }
    }
    
    func sendPhoneCode(phone: String, completion: @escaping (_ resp: GLBaseResp) -> Void) {
        GameleyNetwork.shared.glRequest(.sendPhoneCode, parameters: ["phone": phone]) { (resp: GLBaseResp) in
            completion(resp)
        }
    }
    
    func userLoginPhone(phone: String, code: String, completion: @escaping (_ result: String) -> Void) {
        GameleyNetwork.shared.glRequest(.loginPhone, parameters: ["phone": phone, "code": code], encoding: JSONEncoding.default) { (resp: GLOauthResp) in
            guard resp.state == 0, let info = resp.info else {
                KRProgressHUD.showError(withMessage: resp.msg)
                return
            }
            
            KRProgressHUD.dismiss()
            completion(info.token!)
        }
    }
    
    func getBinds(completion: @escaping (_ resp: GLBnindInfo) -> Void) {
        GameleyNetwork.shared.glRequest(.binds) { (resp: GLBindsResp) in
            guard resp.state == 0, let info = resp.info else {
                KRProgressHUD.showError(withMessage: resp.msg)
                return
            }
            KRProgressHUD.dismiss()
            completion(info)
        }
    }
    
    func updateData(parameters: Parameters? = nil, completion: @escaping () -> Void) {
        GameleyNetwork.shared.glRequest(.updateData, parameters: parameters, encoding: JSONEncoding.default, addMask: false) { (resp: GLBaseResp) in
            guard resp.state == 0 else {
                KRProgressHUD.showError(withMessage: resp.msg)
                return
            }
            completion()
        }
    }
    
    func uploadData(parameters: [String: String], images: [String: UIImage], completion: @escaping (_ resp: GLUploadInfo) -> Void) {
        GameleyNetwork.shared.glUpload(.fileUpload, parameters: parameters, images: images, addMask: false) { (resp: GLUploadResp) in
            guard resp.state == 0, let info = resp.info else {
                return
            }
            completion(info)
        }
    }
}
