//
//  FZUtils.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/14.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

class GLUtil {
    class func getKeyWinddow() -> UIWindow {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return ((UIApplication.shared.delegate?.window)!)!
        }
        return keyWindow
    }
    
    class func getGenderCode(str: String) -> Int {
        switch str {
        case "男": return 0
        case "女": return 1
        default: return 2
        }
    }
}
