//
//  GlUserInfoVC.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/19.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GlUserInfoVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let genderOptions = ["男", "女", "保密"]
    let areaOptions = ["香港", "大陆"]
    
    
    @IBOutlet weak var iconAccessoryImg: UIImageView!
    @IBOutlet weak var nickNameAccessoryLabel: UILabel!
    @IBOutlet weak var genderAccessoryLabel: UILabel!
    @IBOutlet weak var birthAccessoryLabel: UILabel!
    @IBOutlet weak var areaAccessoryLabel: UILabel!
    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePicket = UIImagePickerController()
        imagePicket.delegate = self
        imagePicket.sourceType = .photoLibrary
        imagePicket.allowsEditing = true
        imagePicket.mediaTypes = ["public.image"]
        return imagePicket
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
    }
    
    // 打开图片选择器
    func selectorSourceType(type: UIImagePickerControllerSourceType) {
        imagePickerController.sourceType = type
        present(imagePickerController, animated: true, completion: nil)

    }
    
    // MARK: 当图片选择器选择了一张图片之后回调
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        // TODO 提交图片
        if imagePickerController.allowsEditing {
             iconAccessoryImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        } else {
            iconAccessoryImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
    }
    
    // MARK: 当点击图片选择器中的取消按钮时回调
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            // 取消按钮
            controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            // 拍照选择
            controller.addAction(UIAlertAction(title: "拍照", style: .default) { action in
                self.selectorSourceType(type: .camera)
            })
            // 相册选择
            controller.addAction(UIAlertAction(title: "相册", style: .default) { action in
                self.selectorSourceType(type: .photoLibrary)
            })
            present(controller, animated: true, completion: nil)
        case 1:
            switch indexPath.row {
            // 昵称
            case 0:
                print("昵称")
            case 1:
                let genderPickerView = GLSinglePickerView(options: genderOptions, default: genderAccessoryLabel.text!) { selected in
                    // TODO 提交服务器
                    
                    self.genderAccessoryLabel.text = selected
                    self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 1)], with: .none)
                }
                tableView.addSubview(genderPickerView)
            case 2:
                let birthPickerView = GLBirthPickerView(default: birthAccessoryLabel.text!) { selected in
                    self.birthAccessoryLabel.text = selected
                    self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 1)], with: .none)
                }
                tableView.addSubview(birthPickerView)
            case 3:
                let areaPickerView = GLSinglePickerView(options: areaOptions, default: areaAccessoryLabel.text!) { selected in
                    // TODO 提交服务器
                    
                    self.areaAccessoryLabel.text = selected
                    self.tableView.reloadRows(at: [IndexPath.init(row: 3, section: 1)], with: .none)
                }
                tableView.addSubview(areaPickerView)
            default:
                print(233333)
            }
        case 2:
            print(2)
        default:
            print(233333)
        }
    }

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
