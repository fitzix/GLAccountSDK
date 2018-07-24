//
//  GLTestTableViewController.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/14.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GlUserSettingVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func returnGame(_ sender: UITapGestureRecognizer) {
        GlFloatButton.shared.userBtn.isEnabled = true
        dismiss(animated: true, completion: nil)
    }

}
