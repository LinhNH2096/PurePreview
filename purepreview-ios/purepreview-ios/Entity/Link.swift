//
//  Link.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 15/07/2021.
//

import Foundation
class Link: NSObject, NSCoding {
    var value: String = ""
    var accessAt: Date = Date()
    
    init(value: String, accessAt: Date){
        self.value = value
        self.accessAt = accessAt
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
        aCoder.encode(accessAt, forKey: "accessAt")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.value = aDecoder.decodeObject(forKey: "value") as! String
        self.accessAt = aDecoder.decodeObject(forKey: "accessAt") as! Date
    }
}
