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
    
    struct GLRegex {
        let regex: NSRegularExpression?
        
        init(_ pattern: String) {
            regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        }
        
        func match(input: String) -> Bool {
            if let matches = regex?.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)) {
                return matches.count > 0
            } else {
                return false
            }
        }
    }
}
