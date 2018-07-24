//
//  GameleySDK.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/5.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import MonkeyKing

let kScreen_W = UIScreen.main.bounds.width
let kScreen_H = UIScreen.main.bounds.height

@objcMembers class GameleySDK: NSObject {
    
    // gameley 后台分配APPID
    public var appId: String?
    // 代理类
    public var delegate: GameleySdkDelegate?
    
    let GLBundle = Bundle(identifier: "com.github.fitzix.GameleySDK")
    
    // 显示配置
    
    // 是否启用悬浮球
    public var useAssistive = true
    
    var registedType: [GLAccount: Bool] = [.weChat: false, .qq: false, .weibo: false]
    
    // 实例
    public static let shared = GameleySDK()
    
    public class func registerWeChat(appID: String) {
        MonkeyKing.registerAccount(.weChat(appID: appID, appKey: nil, miniAppID: nil))
        shared.registedType[.weChat] = true
    }
    
    public class func registerQQ(appID: String) {
        MonkeyKing.registerAccount(.qq(appID: appID))
        shared.registedType[.qq] = true
    }
    
    public class func registerWeibo(appID: String, redirectURL: String) {
        MonkeyKing.registerAccount(.weibo(appID: appID, appKey: "", redirectURL: redirectURL))
        shared.registedType[.weibo] = true
    }
    
    
//  登录按钮  调起登录界面
    public func login() {
        if !LocalStore.isLogin {
            getControllerFromStoryboard(clazz: GLLoginModalVC.self).show()
            return
        }
        if let userInfo = LocalStore.getObject(key: .userInfo, object: GLUserInfo()) {
            didLogin(userInfo: userInfo)
        }
    }
    
//   根据类获取storyboard controller
    func getControllerFromStoryboard<T: UIViewController>(clazz: T.Type) -> T {
        return UIStoryboard(name: "Gameley", bundle: GameleySDK.shared.GLBundle).instantiateViewController(withIdentifier: clazz.className) as! T
    }
    
    func logout() {
        
    }
    
    func didLogin(userInfo: GLUserInfo) {
        if useAssistive {
            GlFloatButton.shared.showFloatButton()
        }
        //TODO
        delegate?.didLogin?(userInfo: userInfo)
    }
}
