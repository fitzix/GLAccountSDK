//
//  GLInputPickerView.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/20.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLInputPickerViewController: UIViewController {
    
    var userInfo: GLUserInfo?
    var completion: ((_ nickname: String) -> Void)?
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nicknameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nicknameTextField.frame.height))
        nicknameTextField.leftViewMode = .always
        
        nicknameTextField.text = userInfo?.nickname
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(rightBtnItemAction))
    }
    @objc func rightBtnItemAction() {
        // TODO 提交修改返回
        if let name = nicknameTextField.text {
            GameleyApiHandler.shared.updateData(parameters: ["nickname": name]) { [weak self] in
                if let info = self?.userInfo {
                    info.nickname = name
                    LocalStore.save(key: .userInfo, info: info)
                    self?.completion?(name)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
