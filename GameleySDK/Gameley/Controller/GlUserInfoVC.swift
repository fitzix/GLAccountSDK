//
//  GlUserInfoVC.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/19.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GlUserInfoVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let genderOptions = [GLGender.unkonw.title, GLGender.male.title, GLGender.female.title]
//    let areaOptions = ["香港", "大陆"]
    
    var userInfo = LocalStore.getObject(key: .userInfo, object: GLUserInfo())
    
    @IBOutlet weak var iconAccessoryImg: UIImageView!
    @IBOutlet weak var nickNameAccessoryLabel: UILabel!
    @IBOutlet weak var genderAccessoryLabel: UILabel!
    @IBOutlet weak var birthAccessoryLabel: UILabel!
    
    // 绑定section
    
    @IBOutlet weak var bindPhoneCell: UITableViewCell!
    @IBOutlet weak var bindMailCell: UITableViewCell!
    @IBOutlet weak var bindWeChatCell: UITableViewCell!
    @IBOutlet weak var bindQQCell: UITableViewCell!
    @IBOutlet weak var bindWeiboCell: UITableViewCell!
    
    
    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePicket = UIImagePickerController()
        imagePicket.sourceType = .photoLibrary
        imagePicket.delegate = self
        imagePicket.allowsEditing = true
        imagePicket.mediaTypes = ["public.image"]
        return imagePicket
    }()
    
    
    // MARK: 当图片选择器选择了一张图片之后回调
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if imagePickerController.allowsEditing {
            iconAccessoryImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        } else {
            iconAccessoryImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        if let image = iconAccessoryImg.image {
            GameleyApiHandler.shared.uploadData(parameters: ["type": "2"], images: ["file": image]) { [weak self] resp in
                if let info = self?.userInfo {
                    info.icon = resp.url
                    GameleyApiHandler.shared.updateData(parameters: info.toJSON()) {
                        self?.userInfo = info
                        LocalStore.save(key: .userInfo, info: info)
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        loadData()
    }
    
    // 打开图片选择器
    func selectorSourceType(type: UIImagePickerControllerSourceType) {
        imagePickerController.sourceType = type
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: 当点击图片选择器中的取消按钮时回调
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                DispatchQueue.main.async { [weak self] in
                    let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    // 取消按钮
                    controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    // 拍照选择
                    controller.addAction(UIAlertAction(title: "拍照", style: .default) { action in
                        self?.selectorSourceType(type: .camera)
                    })
                    // 相册选择
                    controller.addAction(UIAlertAction(title: "相册", style: .default) { action in
                        self?.selectorSourceType(type: .photoLibrary)
                    })
                    self?.present(controller, animated: true, completion: nil)
                }
            // 昵称
            case 1:
                let toVC = GameleySDK.shared.getControllerFromStoryboard(clazz: GLInputPickerViewController.self)
                toVC.userInfo = userInfo
                toVC.completion = { [weak self] nickname in
                    self?.nickNameAccessoryLabel.text = nickname
                }
                navigationController?.pushViewController(toVC, animated: true)
            // 性别
            case 2:
                let genderPickerView = GLSinglePickerView(options: genderOptions, default: genderAccessoryLabel.text!) { [weak self] selected in
                    if let info = self?.userInfo {
                        info.gender = GLUtil.getGenderCode(str: selected)
                        GameleyApiHandler.shared.updateData(parameters: info.toJSON()) {
                            self?.userInfo = info
                            LocalStore.save(key: .userInfo, info: info)
                        }
                    }
                    
                    self?.genderAccessoryLabel.text = selected
                    self?.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 1)], with: .none)
                }
                tableView.addSubview(genderPickerView)
            // 生日
            case 3:
                let birthPickerView = GLBirthPickerView(default: birthAccessoryLabel.text!) { [weak self] selected in
                    if let info = self?.userInfo {
                        info.gBirth = selected
                        GameleyApiHandler.shared.updateData(parameters: info.toJSON()) {
                            self?.userInfo = info
                            LocalStore.save(key: .userInfo, info: info)
                        }
                    }
                    self?.birthAccessoryLabel.text = selected
                    self?.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 1)], with: .none)
                }
                tableView.addSubview(birthPickerView)
            default: break
            }
        // 绑定section
        case 1:
            switch indexPath.row {
            case 0:
                let toVC = GameleySDK.shared.getControllerFromStoryboard(clazz: GLBindPhoneViewController.self)
                if bindPhoneCell.accessoryType == .checkmark {
                    toVC.newBind = false
                    toVC.curPhoneNumber = bindPhoneCell.detailTextLabel?.text
                }
                toVC.completion = { [weak self] in
                    self?.loadData()
                }
                navigationController?.pushViewController(toVC, animated: true)
            // 绑定微信
            case 2:
                guard GameleySDK.shared.registedType[.weChat]! else {
                    KRProgressHUD.showWarning(withMessage: "暂不支持微信绑定")
                    return
                }
                
                if bindWeChatCell.accessoryType == .checkmark {
                    // 提示解绑
                    xUnbind(type: .weChat)
                } else {
                   xBind(type: .weChat)
                }
            // QQ
            case 3:
                guard GameleySDK.shared.registedType[.qq]! else {
                    KRProgressHUD.showWarning(withMessage: "暂不支持QQ绑定")
                    return
                }
                
                if bindQQCell.accessoryType == .checkmark {
                     xUnbind(type: .qq)
                } else { xBind(type: .qq) }
            case 4:
                guard GameleySDK.shared.registedType[.weibo]! else {
                    KRProgressHUD.showWarning(withMessage: "暂不支持微博绑定")
                    return
                }
                
                if bindWeiboCell.accessoryType == .checkmark {
                    xUnbind(type: .weibo)
                } else { xBind(type: .weibo) }
            default: break
            }
            
        default:
            print(233333)
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    @IBAction func removeView(_ sender: UIBarButtonItem) {
        GlFloatButton.shared.userBtn.isEnabled = true
        dismiss(animated: false, completion: nil)
    }
    
    
    func loadData() {
        if let url = userInfo?.icon, let imgURL = URL(string: url) {
            iconAccessoryImg.load(url: imgURL)
        }
        nickNameAccessoryLabel.text = userInfo?.nickname
        if let gender = userInfo?.gender {
            genderAccessoryLabel.text = GLGender(rawValue: gender)?.title
        }
        if let gBirth = userInfo?.gBirth {
            print(gBirth.prefix(10))
            birthAccessoryLabel.text = String(gBirth.prefix(10))
        }
        
        GameleyApiHandler.shared.getBinds() { [weak self] binds in
            
            print(binds.toJSON())
            if let phone = binds.phone {
                self?.bindPhoneCell.accessoryType = .checkmark
                self?.bindPhoneCell.detailTextLabel?.text = phone
            } else {
                self?.bindPhoneCell.accessoryType = .disclosureIndicator
                self?.bindPhoneCell.detailTextLabel?.text = ""
            }
            
            
            if let mail = binds.email {
                self?.bindMailCell.accessoryType = .checkmark
                self?.bindMailCell.detailTextLabel?.text = mail
            }else {
                self?.bindMailCell.accessoryType = .disclosureIndicator
                self?.bindMailCell.detailTextLabel?.text = ""
            }
            
            if binds.wx != nil  {
                self?.bindWeChatCell.accessoryType = .checkmark
                self?.bindWeChatCell.detailTextLabel?.text = "已绑定"
            }else {
                self?.bindWeChatCell.accessoryType = .disclosureIndicator
                self?.bindWeChatCell.detailTextLabel?.text = ""
            }
            
            if binds.qq != nil {
                self?.bindQQCell.accessoryType = .checkmark
                self?.bindQQCell.detailTextLabel?.text = "已绑定"
            }else {
                self?.bindQQCell.accessoryType = .disclosureIndicator
                self?.bindQQCell.detailTextLabel?.text = ""
            }
            if binds.wb != nil {
                self?.bindWeiboCell.accessoryType = .checkmark
                self?.bindWeiboCell.detailTextLabel?.text = "已绑定"
            } else {
                self?.bindWeiboCell.accessoryType = .disclosureIndicator
                self?.bindWeiboCell.detailTextLabel?.text = ""
            }
        }
    }
    
    func xUnbind(type: GLAccount) {
        DispatchQueue.main.async { [weak self] in
            // 创建
            let alertController = UIAlertController(title: "提示", message: "你确定要解绑？", preferredStyle:.alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "解绑", style: .default) { [weak self] _ in
                GameleyNetwork.shared.glRequest(.oauthUnbind, appendURL: "/\(type.rawValue)") { [weak self] (resp: GLBaseResp) in
                    guard resp.state == 0 else {
                        KRProgressHUD.showError(withMessage: resp.msg)
                        return
                    }
                    self?.loadData()
                }
            }
            // 添加
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            // 弹出
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func xBind(type: GLAccount) {
        var params: Parameters?
        
        switch type {
        case .weChat:
            
            MonkeyKing.oauth(for: .weChat) { [weak self] (dic, resp, err) in
                guard let wxCode = dic?["code"] as? String else {
                    KRProgressHUD.showError(withMessage: "登录失败")
                    return
                }
                params?["code"] = wxCode
                self?.bind(type: type, parameters: params)
            }
        case .qq:
            MonkeyKing.oauth(for: .qq, scope: "get_user_info") { [weak self] (info, resp, err) in
                guard let unwrappedInfo = info, let token = unwrappedInfo["access_token"] as? String, let openID = unwrappedInfo["openid"] as? String else {
                    KRProgressHUD.showError(withMessage: "登录失败")
                    return
                }
                params?["accessToken"] = token
                params?["openId"] = openID
                self?.bind(type: type, parameters: params)
            }
        case .weibo:
            MonkeyKing.oauth(for: .weibo) { [weak self] (info, response, error) in
                guard let unwrappedInfo = info, let token = (unwrappedInfo["access_token"] as? String) ?? (unwrappedInfo["accessToken"] as? String), let userID = (unwrappedInfo["uid"] as? String) ?? (unwrappedInfo["userID"] as? String) else {
                    KRProgressHUD.showError(withMessage: "登录失败")
                    return
                }
                params?["accessToken"] = token
                params?["openId"] = userID
                self?.bind(type: type, parameters: params)
            }
        }
    }
    
    func bind(type: GLAccount, parameters: Parameters?) {
        var params = parameters
        
        if let token = LocalStore.get(key: .userToken) {
            params?["state"] = "\(type.key).\(token)"
        }
        var url = GLConfig.GLRequestURL.oauthBind
        
        if type == .weChat {
            url = .oauthBindWx
        }
        
        GameleyNetwork.shared.glRequest(url, parameters: params) { [weak self] (resp: GLBaseResp) in
            print(resp.toJSON())
            guard resp.state == 0 else {
                KRProgressHUD.showError(withMessage: resp.msg)
                return
            }
            self?.loadData()
        }
    }
}
