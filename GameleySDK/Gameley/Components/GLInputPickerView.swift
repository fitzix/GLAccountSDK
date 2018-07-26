//
//  GLInputPickerView.swift
//  GameleySDK
//
//  Created by Fitz Leo on 2018/6/20.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class GLInputPickerView: UITextView, UITextViewDelegate {
    lazy var characterNumLabel: UILabel = {
        let temp = UILabel(frame: CGRect(x: kScreen_W - 10 - 40, y: kScreen_H - 64 - 20 - 10, width: 40, height: 15))
        temp.backgroundColor = UIColor.clear
        temp.font = UIFont.systemFont(ofSize: 12)
        return temp
    }()
    var maxCharacterNum: Int
    var warningColor: UIColor

    init(longText: String, maxCharacterNum: Int, warningColor: UIColor) {
        self.maxCharacterNum = maxCharacterNum
        self.warningColor = warningColor

        super.init(frame: CGRect(x: 0, y: 10, width: kScreen_W, height: kScreen_H - 64 - 20), textContainer: nil)
        characterNumLabel.text = longText
        backgroundColor = UIColor.white

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
