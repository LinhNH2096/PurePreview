//
//  WebViewViewController.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 14/07/2021.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift

class WebViewViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: IBOutlet
    @IBOutlet weak var webview: FullScreenWKWebView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var reloadButton: CustomButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    private func setup() {
        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never
        }
        webview.configuration.mediaTypesRequiringUserActionForPlayback = .all
        webview.load(URLRequest(url: url))
    }
    
    private func binding() {
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        reloadButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.webview.reload()
            })
            .disposed(by: disposeBag)
        
        Driver.merge(
            webview.rx.didStartLoad.asDriverOnErrorJustComplete().map({ _ in true}),
            webview.rx.didCommit.asDriverOnErrorJustComplete().map({ _ in true}),
            webview.rx.didFailLoad.asDriverOnErrorJustComplete().map({ _ in false}),
            webview.rx.didFinishLoad.asDriverOnErrorJustComplete().map({ _ in false}),
            closeButton.driver().map({ _ in false})
        ).drive(onNext: { [weak self] isLoading in
            self?.reloadButton.isValidate = !isLoading
            isLoading ? self?.loadingView.startAnimating() : self?.loadingView.stopAnimating()
        })
        .disposed(by: disposeBag)
    }
}

class FullScreenWKWebView: WKWebView {
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
