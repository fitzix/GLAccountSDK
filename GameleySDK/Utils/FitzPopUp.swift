//
//  FitzPopUp.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/5.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class FitzPopUp: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        modalPresentationStyle = .overCurrentContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: Public Methods
    
    public func show(above viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController, completion: (()-> Void)? = nil, animated: Bool = true) {
        viewController?.present(self, animated: animated, completion: completion)
    }
    
    public func dismiss(completion: (()-> Void)? = nil) {
        dismiss(animated: true) {
            completion?()
        }
    }
    
}

