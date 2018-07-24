//
//  GlResetVC.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/15.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GlResetVC: UIViewController {
    
    let datePicker = UIDatePicker()
    
    
    @IBOutlet weak var datePickerText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(23333)
        // Do any additional setup after loading the view.
        createDatePicker()
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        toolbar.setItems([cancelButton, doneButton], animated: false)

        datePickerText.inputAccessoryView = toolbar
        
        datePickerText.inputView = datePicker
        
    }

}
