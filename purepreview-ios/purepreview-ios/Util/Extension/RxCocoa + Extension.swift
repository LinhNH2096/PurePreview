//
//  RxCocoa + Extension.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 15/07/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UITextField {
    public func driver() -> Driver<String> {
      return rx.text.orEmpty.asDriver()
    }
    public func value() -> Driver<String> {
      let text = rx.observe(String.self, "text").map({ $0 ?? "" }).asDriverOnErrorJustComplete()
      return Driver.merge(driver(), text).distinctUntilChanged()
    }
}

extension UIButton {
    public func driver() -> Driver<Void> {
      return rx.tap.asDriver()
    }
}

extension UITextView {
    public func driver() -> Driver<String> {
      return rx.text.orEmpty.asDriver()
    }
    public func value() -> Driver<String> {
      let text = rx.observe(String.self, "text").map({ $0 ?? "" }).asDriverOnErrorJustComplete()
      return Driver.merge(driver(), text).distinctUntilChanged()
    }
}
