//
//  ScanQRViewController.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 17/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class ScanQRViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var scanView: QRScannerView!
    @IBOutlet weak var closeButon: UIButton!
    
    // MARK: Properties
    public var completion: ((String) -> Void)?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        binding()
    }
    
    private func setup() {
        scanView.delegate = self
        scanView.startScanning()
    }
    
    private func binding() {
        closeButon.driver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension ScanQRViewController: QRScannerViewDelegate {
    func qrScanningDidFail() {}
    
    func qrScanningSucceededWithCode(_ str: String?) {
        guard let code = str else { return }
        completion?(code)
        self.dismiss(animated: true, completion: nil)
    }
    
    func qrScanningDidStop() {}
}
