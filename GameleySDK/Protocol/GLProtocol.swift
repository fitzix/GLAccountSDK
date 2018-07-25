//
//  GLProtocol.swift
//  GameleySDK
//
//  Created by fitz on 2018/7/24.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

@objc public protocol GameleySdkDelegate {
    @objc optional func didLogin(userInfo: GLUserInfo)
    @objc optional func didLogout()
}
