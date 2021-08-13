//
//  File.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 15/07/2021.
//

import Foundation
class LinkService {
    class func save(link: Link){
        var linkArray:[Link] = retrive()
        if let index = linkArray.firstIndex(where: { $0.value == link.value }) {
            linkArray.remove(at: index)
        }
        linkArray.append(link)
        let linkArrayAchived = NSKeyedArchiver.archivedData(withRootObject: linkArray)
        UserDefaults.standard.set(linkArrayAchived, forKey: "linkArray")
    }
    
    class func saveListOfLink(value: [Link]) {
        let arrayAchived = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(arrayAchived, forKey: "linkArray")
    }
    
    class func retrive() -> [Link] {
        let linkData = UserDefaults.standard.object(forKey: "linkArray") as? NSData
        if linkData == nil
        {
            return [Link]()
        }
        let linkArray = NSKeyedUnarchiver.unarchiveObject(with: linkData! as Data) as? [Link]
        return linkArray!
    }
    
    class func remove(link: Link) -> [Link] {
        var linkArray:[Link] = retrive()
        guard let index = linkArray.firstIndex(where: { $0.value == link.value })
        else { return linkArray }
        linkArray.remove(at: index)
        saveListOfLink(value: linkArray)
        return linkArray
    }
}
