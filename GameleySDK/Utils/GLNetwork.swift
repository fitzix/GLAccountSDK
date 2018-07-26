//
// Created by Fitz Leo on 2018/6/8.
// Copyright (c) 2018 Fitz Leo. All rights reserved.
//

import Foundation

class GameleyNetwork {
    
    var GLHeaders: HTTPHeaders? {
        get {
            if let token = LocalStore.get(key: .userToken) {
                return [ "Authorization": token, "Accept": "application/json" ]
            }
            return nil
        }
    }
    
//    instance
    static let shared = GameleyNetwork()
    
    func glRequest<T: GLBaseResp>(_ url: GLConfig.GLRequestURL, parameters: Parameters? = nil, appendUrl: String? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, addMask: Bool = true, completion: @escaping (T) -> Void){
    
        let req = request("\(GLConfig.GLHttpGateway)\(url.service)\(url.rawValue)\(appendUrl ?? "")", method: url.method, parameters: parameters, encoding: encoding, headers: GLHeaders)
        if addMask { KRProgressHUD.show() }
        req.responseObject { (response: DataResponse<T>) in
            guard let result = response.result.value, let state = result.state  else {
                KRProgressHUD.showError(withMessage: "请求失败")
                return
            }
            if state == -6 {
                KRProgressHUD.showError(withMessage: "登录超时,重新登录")
                GameleySDK.shared.didLogout()
                return
            }
            
            completion(result)
        }
    }
    
    func glUpload<T: GLBaseResp>(_ url: GLConfig.GLRequestURL, parameters: [String: String]? = nil, images: [String:UIImage]? = nil, addMask: Bool = true, completion: @escaping (T) -> Void){
       
        if addMask { KRProgressHUD.show() }
        
        upload(
            multipartFormData: { multipartFormData in
                parameters?.forEach({
                    multipartFormData.append(($0.value.data(using: .utf8))!, withName: $0.key)
                })
                images?.forEach({
                    if let imageData = UIImagePNGRepresentation($0.value) {
                        multipartFormData.append(imageData, withName: $0.key, fileName: "file-\($0.key).png", mimeType: "image/png")
                    }
                })
            },
            to: "\(GLConfig.GLHttpGateway)\(url.service)\(url.rawValue)",
            method: url.method,
            headers: GLHeaders,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseObject { (response: DataResponse<T>) in
                        guard let result = response.result.value, let state = result.state  else {
                            KRProgressHUD.showError(withMessage: "请求失败")
                            return
                        }
                        if state == -6 {
                            KRProgressHUD.showError(withMessage: "重新登录")
                            GameleySDK.shared.didLogout()
                            return
                        }
                        completion(result)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )

    }
    
}
