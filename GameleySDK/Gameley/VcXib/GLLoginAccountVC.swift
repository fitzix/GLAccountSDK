//
//  GLLoginAccountVC.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/11.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLLoginAccountVC: UIViewController {
    
    @IBOutlet weak var loginAccount: UITextField!
    @IBOutlet weak var loginPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginAccount.setBottomBorder()
        loginPassword.setBottomBorder()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginNormal(_ sender: UIButton) {
        view.endEditing(true)
        
        GameleyApiHandler.shared.userLoginNormal(account: loginAccount.text ?? "", password: loginPassword.text ?? "") { token in
            
            LocalStore.save(key: .userToken, info: token)
            
            GameleyApiHandler.shared.getUserInfo{ userInfo in
                self.dismiss(animated: false, completion: nil)
                GameleySDK.shared.didLogin(userInfo: userInfo)
            }
        }
    }
    
}
