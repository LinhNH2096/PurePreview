//
//  HomeViewModel.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 15/07/2021.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel: BaseViewModel {
    
    private let links = BehaviorRelay<[Link]>(value: [])
    
    func transform(input: Input) -> Output {
        let output = Output(links: links.map({ $0.sorted(by: { $0.accessAt > $1.accessAt}) }).asDriverOnErrorJustComplete())
        getAllLink()
        handleAccessLink(input: input)
        removeLink(input: input)
        return output
    }
    
    private func getAllLink() {
        let allLinks = LinkService.retrive()
        links.accept(allLinks)
    }
    
    private func handleAccessLink(input: Input) {
        input.accessLink
            .drive(onNext: {[weak self] link in
                LinkService.save(link: Link(value: link.value, accessAt: Date()))
                let allLinks = LinkService.retrive()
                self?.links.accept(allLinks)
            })
            .disposed(by: disposeBag)
    }
    
    private func removeLink(input: Input) {
        input.removeLink
            .drive(onNext: {[weak self] link in
                let newLinks = LinkService.remove(link: link)
                self?.links.accept(newLinks)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewModel: ViewModelTransformable {
    struct Input {
        let removeLink: Driver<Link>
        let accessLink: Driver<Link>
    }
    
    struct Output {
        let links: Driver<[Link]>
    }
}
