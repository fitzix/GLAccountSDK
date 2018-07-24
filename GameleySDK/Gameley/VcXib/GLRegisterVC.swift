//
//  GLRegisterVC.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/11.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLRegisterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func removeView(_ sender: UIButton) {
        view.removeFromSuperview()
    }
    
}
