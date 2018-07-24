//
//  GLInputPickerView.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/20.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLInputPickerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createVC() {
        navigationItem.title = "昵称"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(leftBarButtonItemAction))
        
    }
    
    @objc func leftBarButtonItemAction() {
        navigationController?.popViewController(animated: true)
    }
}
