//
//  ViewController.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 14/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var inputURLTextField: UITextField!
    @IBOutlet weak var enterButton: CustomButton!
    @IBOutlet weak var scanQRButton: UIButton!
    @IBOutlet weak var historyLinkTableView: UITableView!
    @IBOutlet weak var video30sSwitch: UISwitch!
    @IBOutlet weak var video5sSwitch: UISwitch!
    
    // MARK: Subjects
    private let accessLink = PublishSubject<Link>()
    private let removeLink = PublishSubject<Link>()
    private let actionAccessLink = BehaviorRelay<ActionAccessLink>(value: .openWebview)
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        binding()
    }
    
    private func setup() {
        appVersionLabel.text = AppText.appVersion
        historyLinkTableView.register(HistoryLinkTableViewCell.self)
    }
    
    private func binding() {
        let input = HomeViewModel.Input(removeLink: removeLink.asDriverOnErrorJustComplete(),
                                        accessLink: accessLink.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        bindingListLink(output: output)
        bindingAction(output: output)
    }
    
    private func bindingListLink(output: HomeViewModel.Output) {
        output.links
            .drive(historyLinkTableView.rx.items(cellIdentifier: String(describing: HistoryLinkTableViewCell.self), cellType: HistoryLinkTableViewCell.self)
            ) { row, data, cell in
                cell.link = data
                cell.removeTrigger.drive(onNext: { [weak self] _ in
                    self?.removeLink.onNext(data)
                }).disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
    }
    
    private func bindingAction(output: HomeViewModel.Output) {
        // Binding Enter Button State
        inputURLTextField.value()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                let textTrim = text.trimmingCharacters(in: .whitespacesAndNewlines)
                self.enterButton.isValidate =
                    Validation.validate(text: textTrim,
                                        withRegex: .url)
                    && Validation.verifyURL(urlString: textTrim)
            })
            .disposed(by: disposeBag)
        
        // Binding Two Switch State
        video5sSwitch.rx.isOn
            .filter({ $0 })
            .map({ !$0 })
            .asDriverOnErrorJustComplete()
            .drive(video30sSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        video30sSwitch.rx.isOn
            .filter({ $0 })
            .map({ !$0 })
            .asDriverOnErrorJustComplete()
            .drive(video5sSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        // Binding Navigate Destination
        Driver.merge(
            historyLinkTableView.rx.modelSelected(Link.self) .asDriverOnErrorJustComplete(),
            enterButton.driver().withLatestFrom(inputURLTextField.value())
                .map({ Link(value: $0.trimmingCharacters(in: .whitespacesAndNewlines), accessAt: Date())})
        ).withLatestFrom(actionAccessLink.asDriverOnErrorJustComplete()) { (link: $0, action: $1) }
        .drive(onNext: { [weak self] link, action in
            guard let self = self,
                  let url = URL(string: link.value)
            else { return }
            self.accessLink.onNext(Link(value: link.value, accessAt: Date()))
            self.navigate(action: action, url: url)
        }).disposed(by: disposeBag)
        
        Driver.merge(
            video5sSwitch.rx.isOn.filter({ $0 })
                .map({ _ in ActionAccessLink.playVideo5s })
                .asDriverOnErrorJustComplete(),
            video30sSwitch.rx.isOn.filter({ $0 })
                .map({ _ in ActionAccessLink.playVideo30s })
                .asDriverOnErrorJustComplete(),
            Driver.combineLatest(
                video5sSwitch.rx.isOn.filter({ !$0 }).asDriverOnErrorJustComplete(),
                video30sSwitch.rx.isOn.filter({ !$0 }).asDriverOnErrorJustComplete()
            ).map({ _ in ActionAccessLink.openWebview })
        ).drive(actionAccessLink)
        .disposed(by: disposeBag)
        
        // Binding Scan QRCode
        scanQRButton.driver()
            .drive(onNext: { [weak self] _ in
                let scanQRVC = ScanQRViewController()
                scanQRVC.modalPresentationStyle = .fullScreen
                scanQRVC.completion = { [weak self] code in
                    print("[QR-CODE]:" + code)
                    self?.inputURLTextField.text = code
                }
                self?.present(scanQRVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigate(action: ActionAccessLink, url: URL) {
        switch action {
        case .openWebview:
            let webviewVC = WebViewViewController(url: url)
            webviewVC.modalPresentationStyle = .fullScreen
            self.present(webviewVC, animated: true)
        case .playVideo30s, .playVideo5s:
            let playVideoVC = PlayVideoViewController(url: url, action: action)
            let naviPlayVideoVC = UINavigationController(rootViewController: playVideoVC)
            playVideoVC.modalPresentationStyle = .fullScreen
            naviPlayVideoVC.modalPresentationStyle = .fullScreen
            self.present(naviPlayVideoVC, animated: true)
        }
    }
}

enum ActionAccessLink {
    case playVideo5s
    case playVideo30s
    case openWebview
    
    var filePathVideo: URL? {
        switch self {
        case .playVideo30s:
            return URL(fileURLWithPath: Bundle.main.path(forResource: "Sample30s", ofType: "mp4") ?? "")
        case .playVideo5s:
            return URL(fileURLWithPath: Bundle.main.path(forResource: "Sample5s", ofType: "mp4") ?? "")
        default:
            return URL(string: "")
        }
    }
}
