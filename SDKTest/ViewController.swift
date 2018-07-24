//
//  ViewController.swift
//  SDKTest
//
//  Created by Fitz Leo on 2018/6/5.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import GameleySDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Show(_ sender: UIButton) {
        GameleySDK.login() { userInfo in
            let alert = UIAlertController(title: nil, message: String(describing: userInfo), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}

