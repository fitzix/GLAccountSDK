//
//  FitzExtensions.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/5.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue > 0 ? newValue : 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}

//UISegmentedControl定制

extension UISegmentedControl{
    
    func addUnderlineForSelectedSegment(){
        backgroundColor = .clear
        tintColor = .clear
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.13, green:0.51, blue:0.97, alpha:1.00),NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], for: .selected)
        
        let buttonBar = UIView()
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor(red:0.13, green:0.51, blue:0.97, alpha:1.00)
        buttonBar.tag = 1
        
        addSubview(buttonBar)
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / CGFloat(numberOfSegments)).isActive = true

    }
    
//  切换动画
    func segmentedControlValueChanged(){
        guard let buttonBar = self.viewWithTag(1) else {return}
        
        UIView.animate(withDuration: 0.3) {
            buttonBar.frame.origin.x = (self.frame.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        }
    }
}

// 获取类名
extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

// 输入框只显示底部边框
extension UITextField {
    func setBottomBorder() {
        borderStyle = .none
        layer.backgroundColor = UIColor.white.cgColor
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 0.0
        
    }
}

//通过对String扩展，字符串增加下表索引功能
extension String
{
    subscript(index:Int) -> String
    {
        get{
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set{
            let tmp = self
            self = ""
            for (idx, item) in tmp.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                }else{
                    self += "\(item)"
                }
            }
        }
    }
    
    func sha1() -> String? {
        return SHA1.hexString(from: "abc")
    }
}

// 提示框

extension UIAlertController {
    //在指定视图控制器上弹出普通消息提示框
    static func showAlert(message: String, in viewController: UIViewController, confirm needConfirmBtn: Bool = false) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        if needConfirmBtn {
           alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        }
        viewController.present(alert, animated: true)
    }
    
    static func showAlert(message: String, in viewController: UIViewController, confirm needConfirmBtn: Bool = false, close autoClose: DispatchTime = DispatchTime.now() + 1) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        if needConfirmBtn {
            alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        }
        viewController.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: autoClose) {
            alert.dismiss(animated: false, completion: nil)
        }
    }
    
    
    //在根视图控制器上弹出普通消息提示框
    static func showAlert(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, in: vc)
        }
    }
    
    //在指定视图控制器上弹出确认框
    static func showConfirm(message: String, in viewController: UIViewController,
                            confirm: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: confirm))
        viewController.present(alert, animated: true)
    }
    
    //在根视图控制器上弹出确认框
    static func showConfirm(message: String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(message: message, in: vc, confirm: confirm)
        }
    }
    
    // loading alert
    class func showLoading(in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        viewController.present(alert, animated: true, completion: nil)
    }
}
