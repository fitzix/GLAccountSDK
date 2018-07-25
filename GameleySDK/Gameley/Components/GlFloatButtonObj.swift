//
//  FloatButtonObj.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/15.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

class GlFloatButton {
    static let shared = GlFloatButton()
    
    lazy var userInfoModal: GlUserSettingNavVC?  = GameleySDK.shared.getControllerFromStoryboard(clazz: GlUserSettingNavVC.self)
    
    lazy var spreadButton = SpreadButton(image: UIImage(named: "icon_gameley", in: GameleySDK.shared.GLBundle, compatibleWith: nil),highlightImage: nil, position: CGPoint(x: 40, y: UIScreen.main.bounds.height - 40))
    
    lazy var userBtn: SpreadSubButton = SpreadSubButton(backgroundImage: UIImage(named: "icon_user", in: GameleySDK.shared.GLBundle, compatibleWith: nil), highlightImage: nil) { (index, sender) -> Void in
        sender.isEnabled = false
        GLUtil.getKeyWinddow().rootViewController?.present(GlFloatButton.shared.userInfoModal!, animated: true, completion: nil)
    }
    
    lazy var logoutBtn = SpreadSubButton(backgroundImage: UIImage(named: "icon_logout", in: GameleySDK.shared.GLBundle, compatibleWith: nil), highlightImage: nil) { (index, sender) -> Void in
        
        GlFloatButton.shared.spreadButton?.removeFromSuperview()
        GlFloatButton.shared.userInfoModal?.dismiss(animated: true, completion: nil)
        GlFloatButton.shared.userBtn.isEnabled = true
        
        GameleySDK.shared.didLogout()
    }
    
    func showFloatButton() {
        guard let _ = UserDefaults.standard.string(forKey: "GAMELEY_USER_TOKEN"), let spreadButton = spreadButton else {
            return
        }
        spreadButton.setSubButtons([userBtn, logoutBtn])
        spreadButton.mode = SpreadMode.spreadModeLineSpread
        spreadButton.direction = SpreadDirection.spreadDirectionRightUp
        spreadButton.radius = 50
        spreadButton.positionMode = SpreadPositionMode.spreadPositionModeTouchBorder
        
        GLUtil.getKeyWinddow().addSubview(spreadButton)
    }
}
