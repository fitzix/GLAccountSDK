//
//  GLEnum.swift
//  GameleySDK
//
//  Created by fitz on 2018/7/24.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

enum GLAccount: Int {
    case weChat = 1, qq, weibo
    
    var key: String {
        switch self {
        case .qq: return "qq"
        case .weChat: return "wx"
        case .weibo: return "wb"
        }
    }
}

enum GLGender: Int {
    case unkonw, male, female
    
    var title: String {
        switch self {
        case .male: return "男"
        case .female: return "女"
        case .unkonw: return "未知"
        }
    }
}
