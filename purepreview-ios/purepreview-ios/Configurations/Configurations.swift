//
//  Configurations.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 17/07/2021.
//

import Foundation

enum ConfigurationKey: String {
    case appName = "APP_NAME"
    case appVersion = "APP_VERSION"
    case appBuild = "APP_BUILD"
    case bundleID = "BUNDLE_ID"

    func value() -> String? {
        let value = (Bundle.main.infoDictionary?[self.rawValue] as? String)?.replacingOccurrences(of: "\\", with: "")
        return value
    }
}
