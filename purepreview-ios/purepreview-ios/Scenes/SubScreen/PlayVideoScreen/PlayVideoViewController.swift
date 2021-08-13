//
//  PlayVideoViewController.swift
//  purepreview-ios
//
//  Created by Nguyễn Hồng Lĩnh on 15/07/2021.
//

import UIKit
import AVFoundation
import AVKit
import RxSwift
import RxCocoa

class PlayVideoViewController: UIViewController {
    
    @IBOutlet weak var skipButton: CustomButton!
    
    private let url: URL
    private var action: ActionAccessLink
    private var player: AVPlayer!
    private let disposeBag = DisposeBag()
    
    init(url: URL, action: ActionAccessLink) {
        self.url = url
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppUtility.lockOrientation(.all)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayer()
    }
    
    private func setup() {
        guard let filePathVideo = action.filePathVideo else { return }
        player = AVPlayer(url: filePathVideo)
        setupLayer()
    }
    
    private func setupLayer() {
        let layer = AVPlayerLayer(player: player)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        view.addSubview(skipButton)
    }
    
    private func binding() {
        Driver.merge(NotificationCenter.default
                        .rx.notification(.AVPlayerItemDidPlayToEndTime)
                        .map({ _ in () })
                        .asDriverOnErrorJustComplete(),
                     skipButton.driver())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.player.pause()
                let webviewVC = WebViewViewController(url: self.url)
                self.navigationController?.pushViewController(webviewVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
