//
//  ViewController.swift
//  SDKTest
//
//  Created by Fitz Leo on 2018/6/5.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import GameleySDK

class ViewController: UIViewController, GameleySdkDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GameleySDK.shared.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Show(_ sender: UIButton) {
        GameleySDK.login()
    }
    
    func didLogin(userInfo: GLUserInfo) {
        print(userInfo.toJSON())
    }
}

