//
//  CustomButton.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 15/07/2021.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    var isValidate: Bool = true {
        didSet {
            isEnabled = isValidate
            backgroundColor = isValidate ? #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1) : #colorLiteral(red: 0.8979414105, green: 0.8980956078, blue: 0.8979316354, alpha: 1)
        }
    }
}
