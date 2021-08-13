//
//  Validation.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 17/07/2021.
//

import Foundation
import UIKit

class Validation {
    class func validate(text: String?, withRegex regex: AppConstant.Regex) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex.desc)
        return predicate.evaluate(with: text)
    }
    
    class func verifyURL(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
