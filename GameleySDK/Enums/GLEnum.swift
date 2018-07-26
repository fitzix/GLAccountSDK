//
//  GLEnum.swift
//  GameleySDK
//
//  Created by fitz on 2018/7/24.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

enum GLAccount: Int {
    case weChat, qq, weibo
}

enum GLGender: Int {
    case male, female, unkonw
    
    var title: String {
        switch self {
        case .male: return "男"
        case .female: return "女"
        case .unkonw: return "未知"
        }
    }
}
