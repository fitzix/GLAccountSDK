//
//  GLGenderPickerView.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/19.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLSinglePickerView: UIView {
    
    typealias GLSinglePickerViewCompletion = (_ selected: String) -> Void
    
    lazy var pickerView = UIPickerView(frame: CGRect(x: 0, y: 44, width: kScreen_W, height: 216))
    lazy var bottomView = UIView(frame: CGRect(x: 0, y: kScreen_H - 216 - 44 - 64, width: kScreen_W, height: 216 + 44))
    
    var completionBlock: GLSinglePickerViewCompletion
    var defaultStr: String
    var selectedStr: String
    var options: [String]
    
    init(options optionsArray: [String], default defaultSelected: String, completion: @escaping GLSinglePickerViewCompletion) {
        defaultStr = defaultSelected
        selectedStr = defaultSelected
        options = optionsArray
        completionBlock = completion
        
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
extension GLSinglePickerView{
    
    func creatUI(){
        
        //pickerView
        pickerView.backgroundColor = UIColor.clear
        pickerView.dataSource = self
        pickerView.delegate = self
        //是否要显示选中的指示器(默认值是NO)
        pickerView.showsSelectionIndicator = true
        let selectedIndex = options.index(of: selectedStr) ?? 0
        selectedStr = options[selectedIndex]
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
        
        
        //toolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 44))
        toolBar.backgroundColor = UIColor.white
        
        // 取消按钮
        let leftItem = UIBarButtonItem(title: "  取消", style: .plain, target: self, action: #selector(removePickView))
        leftItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)], for: .normal)
        
        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        // 确定按钮
        let rightItem = UIBarButtonItem(title: "确定  ", style: .done, target: self, action: #selector(doneBtnClicked))
        rightItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)], for: .normal)
        toolBar.items = [leftItem,centerSpace,rightItem]
        
        
        bottomView.backgroundColor = UIColor.white
        
        bottomView.addSubview(pickerView)
        bottomView.addSubview(toolBar)
        
        self.addSubview(bottomView)
    }
}

//MARK: - 点击事件
extension GLSinglePickerView{
    
    @objc func removePickView(){
        self.removeFromSuperview()
    }
    
    @objc func doneBtnClicked()
    {
        completionBlock(selectedStr)
        
        self.removeFromSuperview()
    }
}

//MARK: UIPickerView协议
extension GLSinglePickerView:UIPickerViewDataSource,UIPickerViewDelegate{
    //返回列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //返回行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    //组件每行的标题
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        for subView in pickerView.subviews {
            if subView.frame.size.height <= 1 {
                subView.backgroundColor = UIColor.gray
            }
        }
        return options[row]
    }
    //选中行的事件处理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStr = options[row]
    }
}
