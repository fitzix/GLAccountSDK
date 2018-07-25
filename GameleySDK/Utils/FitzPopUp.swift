//
//  FitzPopUp.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/5.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class FitzPopUp: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .overCurrentContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
    }
    
    public func show(above viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController, completion: (()-> Void)? = nil, animated: Bool = true) {
        viewController?.present(self, animated: animated, completion: completion)
    }
}

