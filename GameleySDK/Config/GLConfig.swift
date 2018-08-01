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
    static let GLChannelID = 4001
    
    enum GLService: String {
        case user_basic = "/gl-ms-user-basic"
        case file_service = "/gl-ms-file-service"
    }
    
    enum GLRequestURL: String {
        case quickRegister = "/register/account"
        case phoneRegister = "/register/phone"
        case mailRegister = "/register/mail"
        case sendRegisterPhoneCode = "/register/send_phone_message"
        
        case passwdResetSendCode = "/passwd/reset/send_code_message"
        case passwdResetCheck = "/passwd/reset/check_code"
        case passwdReset = "/passwd/reset/index"
        
        case loginNormal = "/login/normal"
        case loginPhone = "/login/phone"
        
        case sendPhoneCode = "/login/send_phone_message"
        case sendPhoneCodeUpdate = "/update/send_phone_message"
        
        case userInfo = "/query/user"
        case binds = "/query/bingd"
        case updateData = "/update/data"
        case changeBindVerify = "/update/verification_phone"
        case updatePhone = "/update/phone"
        
        case oauthWx = "/oauth/android/wx"
        case oauthQQ = "/oauth/android/qq"
        case oauthWb = "/oauth/android/wb"
        case oauthUnbind = "/update/unbind"
        
        case oauthBind = "/oauth/android/bind"
        case oauthBindWx = "/oauth/android/bindWx"
        
        case fileUpload = "/file/upload"
        
        var method: HTTPMethod {
            switch self {
            case .userInfo, .binds, .oauthQQ, .oauthWb, .oauthWx, .oauthBind, .oauthBindWx:
                return .get
            case .loginNormal, .loginPhone, .sendPhoneCode, .updateData, .fileUpload, .changeBindVerify, .updatePhone, .sendPhoneCodeUpdate, .quickRegister, .phoneRegister, .mailRegister, .sendRegisterPhoneCode, .passwdResetSendCode, .passwdReset, .passwdResetCheck:
                return .post
            case .oauthUnbind:
                return .patch
            }
        }
        
        var service: String {
            switch self {
            case .fileUpload:
                return GLService.file_service.rawValue
            default:
                return GLService.user_basic.rawValue
            }
        }
        
        var encoding: ParameterEncoding {
            switch self.method {
            case .get: return URLEncoding.default
            case .post: return JSONEncoding.default
            default: return URLEncoding.default
            }
        }
    }
}
