//
// Created by Fitz Leo on 2018/6/8.
// Copyright (c) 2018 Fitz Leo. All rights reserved.
//

import Foundation

class GameleyNetwork {
    
    let httpGateway = "https://test.gw.leuok.com"
    
    enum GLService: String {
        case gd = "/guandao"
        case user_basic = "/gl-ms-user-basic"
    }
    
    var GLHeaders: HTTPHeaders? {
        get {
            if let token = UserDefaults.standard.string(forKey: "GL_GD_TOKEN") {
                return [ "Authorization": token, "Accept": "application/json" ]
            }
            return nil
        }
    }
    
//    instance
    static let shared = GameleyNetwork()
    
    enum GLRequestURL: String {
        case loginNormal = "/login/normal"
        case loginPhone = "/login/phone"
        
        case sendPhoneCode = "/login/send_phone_message"
        
        case userInfo = "/query/user"
        case binds = "/query/bingd"
        
        case oauthWx = "/oauth/android/wx"
        case oauthQQ = "/oauth/android/qq"
        case oauthWb = "/oauth/android/wb"
    }
    
    
    
    public func glRequest<T: GLBaseResp>(_ url: GLRequestURL, service:GLService = .user_basic, method: HTTPMethod = .get, parameters: Parameters? = nil, appendUrl: String? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, addMask: Bool = true, completion: @escaping (T) -> Void){
        var localHeader = headers
        if headers == nil {
            localHeader = GLHeaders
        }
        let req = request("\(httpGateway)\(service.rawValue)\(url.rawValue)\(appendUrl ?? "")", method: method, parameters: parameters, encoding: encoding, headers: localHeader)
        if addMask { KRProgressHUD.show() }
        req.responseObject { (response: DataResponse<T>) in
            guard let result = response.result.value, let state = result.state  else {
                KRProgressHUD.showError(withMessage: "请求失败")
                return
            }
            if state == -6 {
                KRProgressHUD.showError(withMessage: "重新登录")
                LocalStore.logout()
                GameleySDK.shared.logout()
                GameleySDK.shared.delegate?.didLogout?()
                return
            }
            
            completion(result)
        }
    }
}
