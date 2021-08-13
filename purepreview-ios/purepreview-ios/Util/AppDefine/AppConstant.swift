//
//  AppConstant.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 17/07/2021.
//


struct AppConstant {
    // MARK: REGULAR EXPRESSION
    enum Regex: String {
        var desc: String { return rawValue }
        case url = "^((?:http|https)://)?(?:www\\.)?[\\w\\d-_]+\\.\\w{2,100}(\\.\\w{2,100})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?$"
    }
}
