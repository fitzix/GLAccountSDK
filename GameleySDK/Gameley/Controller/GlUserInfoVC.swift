//
//  GlUserInfoVC.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/19.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GlUserInfoVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let genderOptions = [GLGender.male.title, GLGender.female.title, GLGender.unkonw.title]
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
        // TODO 提交图片
        if imagePickerController.allowsEditing {
            iconAccessoryImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        } else {
            iconAccessoryImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        if let image = iconAccessoryImg.image {
            GameleyApiHandler.shared.uploadData(parameters: ["type": "2"], images: ["file": image]) { [weak self] resp in
                print(resp.toJSON())
                self?.userInfo?.icon = resp.url
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
                    
                    GameleyApiHandler.shared.updateData(parameters: ["gender": GLUtil.getGenderCode(str: selected)]) {
                        if let info = self?.userInfo {
                            info.gender = GLUtil.getGenderCode(str: selected)
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
                    
                    GameleyApiHandler.shared.updateData(parameters: ["gBirth": selected]) {
                        if let info = self?.userInfo {
                            info.gBirth = selected
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
//        case 1:
//            switch indexPath.row {
//            case 0:
//                if bindPhoneCell.accessoryType == .checkmark {
//
//                }
//            }
        
        default:
            print(233333)
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
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
            if let phone = binds.phone {
                self?.bindPhoneCell.accessoryType = .checkmark
                self?.bindPhoneCell.detailTextLabel?.text = phone
            }
            if let mail = binds.email {
                self?.bindMailCell.accessoryType = .checkmark
                self?.bindMailCell.detailTextLabel?.text = mail
            }
            if binds.wx != nil  {
                self?.bindWeChatCell.accessoryType = .checkmark
                self?.bindWeChatCell.detailTextLabel?.text = "已绑定"
            }
            if binds.qq != nil {
                self?.bindQQCell.accessoryType = .checkmark
                self?.bindQQCell.detailTextLabel?.text = "已绑定"
            }
            if binds.wb != nil {
                self?.bindWeiboCell.accessoryType = .checkmark
                self?.bindWeiboCell.detailTextLabel?.text = "已绑定"
            }
        }
    }
}
