//
//  GLBirthPickerView.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/20.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLBirthPickerView: UIView {
    
    typealias GLBirthPickerViewCompletion = (_ selected: String) -> Void
    
    let dateformatter = DateFormatter()
    
    lazy var pickerView = UIDatePicker(frame: CGRect(x: 0, y: 44, width: kScreen_W, height: 216))
    lazy var bottomView = UIView(frame: CGRect(x: 0, y: kScreen_H - 216 - 44 - 64, width: kScreen_W, height: 216 + 44))
    
    var completionBlock: GLBirthPickerViewCompletion
    var defaultStr: String
    var selectedStr: String
    
    init(default defaultSelected: String, completion: @escaping GLBirthPickerViewCompletion) {
        defaultStr = defaultSelected
        selectedStr = defaultSelected
        completionBlock = completion
        dateformatter.dateFormat = "YYYY-MM-dd"
        
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        backgroundColor = UIColor.gray.withAlphaComponent(0.618)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.creatUI()
    }
    
}

//MARK: -　界面
extension GLBirthPickerView{
    
    func creatUI(){
        
        //pickerView
        pickerView.backgroundColor = UIColor.clear
        
        /**
         datePicker 的显示模式
         
         UIDatePickerModeTime           显示时间
         UIDatePickerModeDate           显示日期
         UIDatePickerModeDateAndTime    显示日期和时间
         */
        pickerView.datePickerMode = .date
        
        /**
         minimumDate 和 maximumDate
         
         这两个值控制的是用户可用的有效时间范围, 默认值都是nil, nil 意味着没有最小和最大使用的时间约束, 也就是说用户可以随便滚动滚轮选择时间
         如果设置了 minimumDate 和 maximumDate 的值, 那么当用户滚动超出 minimumDate 时会自动回滚到 minimumDate, 当用户滚动超出 maximumDate 时会自动回滚到 maximumDate
         实际开发中根据具体情况来设定这两个值即可, 此处为生日选择, 所以可以是过去的任意时间和当前日期
         */
        pickerView.maximumDate = Date()
        
        let defaultDate = dateformatter.date(from: selectedStr) ?? Date()
        selectedStr = dateformatter.string(from: defaultDate)
        pickerView.date = defaultDate
        
        pickerView.addTarget(self, action: #selector(datePickerDidChanged(datePicker:)), for: .valueChanged)
        
        
        //toolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 44))
        toolBar.backgroundColor = UIColor.white
        
        // 取消按钮
        let leftItem = UIBarButtonItem(title: "  取消", style: .plain, target: self, action: #selector(removePickView))
        leftItem.setTitleTextAttributes([.font:UIFont.systemFont(ofSize: 17)], for: .normal)
        
        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        // 确定按钮
        let rightItem = UIBarButtonItem(title: "确定  ", style: .done, target: self, action: #selector(doneBtnClicked))
        rightItem.setTitleTextAttributes([.font:UIFont.systemFont(ofSize: 17)], for: .normal)
        toolBar.items = [leftItem,centerSpace,rightItem]
        
        
        bottomView.backgroundColor = UIColor.white
        
        bottomView.addSubview(pickerView)
        bottomView.addSubview(toolBar)
        
        self.addSubview(bottomView)
    }
}

//MARK: - 点击事件
extension GLBirthPickerView{
    
    @objc func removePickView(){
        self.removeFromSuperview()
    }
    
    @objc func doneBtnClicked()
    {
        completionBlock(selectedStr)
        
        self.removeFromSuperview()
    }
    
    @objc func datePickerDidChanged(datePicker: UIDatePicker) {
        selectedStr = dateformatter.string(from: datePicker.date)
    }
}
