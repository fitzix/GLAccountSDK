//
//  LocalStore.swift
//  GameleySDK
//
//  Created by fitz on 2018/7/24.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

class LocalStore {
    enum GLStoreKey: String {
        case userToken = "GL_GD_TOKEN"
        case userInfo = "GL_GD_USER_INFO"
    }
     static var isLogin: Bool {
        get {
            return get(key: .userToken) != nil
        }
    }
    
    class func login(info: GLUserInfo) {
        save(key: .userInfo, info: info)
    }
    
    class func logout() {
        UserDefaults.standard.removeObject(forKey: GLStoreKey.userInfo.rawValue)
        UserDefaults.standard.removeObject(forKey: GLStoreKey.userToken.rawValue)
    }
    
    class func save(key: GLStoreKey, info: Mappable) {
        if let str = info.toJSONString() {
            UserDefaults.standard.set(str, forKey: key.rawValue)
        }
    }
    
    class func save(key: GLStoreKey, info: String?) {
        if let str = info {
            UserDefaults.standard.set(str, forKey: key.rawValue)
        }
    }
    
    class func get(key: GLStoreKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    class func getObject<T: Mappable>(key: GLStoreKey, object: T) -> T?{
        if let objStr = get(key: key) {
            return T(JSONString: objStr)
        }
        return nil
    }
}
