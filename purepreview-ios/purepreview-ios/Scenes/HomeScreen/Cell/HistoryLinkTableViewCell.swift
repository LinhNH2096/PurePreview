//
//  HistoryLinkTableViewCell.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 15/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryLinkTableViewCell: UITableViewCell {
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var historyLinkLabel: UILabel!
    
    var link: Link? {
        didSet {
            historyLinkLabel.text = link?.value
        }
    }
    
    private(set) var disposeBag = DisposeBag()
    
    var removeTrigger: Driver<Void> {
        return removeButton.driver()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
