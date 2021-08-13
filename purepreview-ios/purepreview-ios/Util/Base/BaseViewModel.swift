//
//  BaseViewModel.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 15/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

public protocol ViewModelTransformable: AnyObject {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
class BaseViewModel: NSObject {
    internal var disposeBag: DisposeBag!
    internal var appError = PublishSubject<AppError>()
    
    public override init() {
        disposeBag = DisposeBag()
        super.init()
    }
    deinit {
        #if DEBUG
        print("\(String(describing: self)) deinit.")
        #endif
    }
}
