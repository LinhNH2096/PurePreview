//
//  AppError.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 15/07/2021.
//

import Foundation
struct AppError: Codable, Error {
  var data: Data?
  var message: String = ""
  var success: Bool = false
}
