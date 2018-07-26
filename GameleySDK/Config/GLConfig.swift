//
//  GLConfig.swift
//  GameleySDK
//
//  Created by fitz on 2018/7/26.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

class GLConfig {
    
    static let GLHttpGateway = "https://test.gw.leuok.com"
    
    enum GLService: String {
        case user_basic = "/gl-ms-user-basic"
        case file_service = "/gl-ms-file-service"
    }
    
    enum GLRequestURL: String {
        case loginNormal = "/login/normal"
        case loginPhone = "/login/phone"
        
        case sendPhoneCode = "/login/send_phone_message"
        
        case userInfo = "/query/user"
        case binds = "/query/bingd"
        case updateData = "/update/data"
        
        case oauthWx = "/oauth/android/wx"
        case oauthQQ = "/oauth/android/qq"
        case oauthWb = "/oauth/android/wb"
        
        case fileUpload = "/file/upload"
        
        var method: HTTPMethod {
            switch self {
            case .userInfo, .binds, .oauthQQ, .oauthWb, .oauthWx:
                return .get
            case .loginNormal, .loginPhone, .sendPhoneCode, .updateData, .fileUpload:
                return .post
            }
        }
        
        var service: String {
            switch self {
            case .loginNormal, .loginPhone, .sendPhoneCode, .userInfo, .binds, .updateData, .oauthWx, .oauthQQ, .oauthWb:
                return GLService.user_basic.rawValue
            case .fileUpload:
                return GLService.file_service.rawValue
            }
        }
    }
}
