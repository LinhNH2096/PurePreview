//
//  AppText.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 17/07/2021.
//

import Foundation

struct AppText {
    static var appVersion: String {
        return "Version \(ConfigurationKey.appVersion.value() ?? "1.0.0") (c) Pureative"
    }
    
    static var messageUnableAccessCamere: String {
       return "Please check system settings for permission"
    }
    
    static var titleUnableAccessCamere: String {
       return "Unable to access your camera"
    }
}
