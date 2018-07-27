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
    
    func glRequest<T: GLBaseResp>(_ url: GLConfig.GLRequestURL, appendURL: String = "", parameters: Parameters? = nil, encoding: ParameterEncoding? = nil, headers: HTTPHeaders? = nil, addMask: Bool = true, completion: @escaping (T) -> Void){
        var encode = encoding
        if encoding == nil {
            encode = url.encoding
        }
        
        let req = request("\(GLConfig.GLHttpGateway)\(url.service)\(url.rawValue)\(appendURL)", method: url.method, parameters: parameters, encoding: encode!, headers: GLHeaders)
        debugPrint(req)
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
                    
                    if let imageData = UIImageJPEGRepresentation($0.value, 0.5) {
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
                        debugPrint(response)
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
