//
//  RocketExpoPlayerViewController.swift
//  Shift72RocketSDKExpo
//
//  Created by Declan ter Veer-Burke on 06/11/2025.
//

import UIKit
import AVKit
import Shift72RocketSDK

class RocketExpoPlayerViewController: UIViewController {
    private var playerViewController: AVPlayerViewController?
    private var playerView: AVPlayer?
    private var player: RocketPlayer?
    let hostname: String
    let slug: String
    let token: String
    let eventDelegate: RocketExpoEventsDelegate
    
    init(hostname: String, slug: String, token: String, eventDelegate: RocketExpoEventsDelegate) {
        self.hostname = hostname
        self.slug = slug
        self.token = token
        self.eventDelegate = eventDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("This class does not support init from NIB")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerView = AVPlayer()
        let pvc = AVPlayerViewController()
        self.playerViewController = pvc
        pvc.player = playerView
        self.addChild(pvc)
        // make video view
        pvc.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pvc.view)
        NSLayoutConstraint.activate([
            pvc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pvc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pvc.view.topAnchor.constraint(equalTo: view.topAnchor),
            pvc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        pvc.didMove(toParent: self)
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscape]
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        self.eventDelegate.onFullscreenPlayerOpened()
        guard let pvc = self.playerViewController, let pv = self.playerView else {
            RocketExpoModule.loggerDelegate.error(message: "\(String(describing: Self.self)) AVPlayerVC or AVPlayer nil before viewDidAppear?!")
            return
        }
        let delegate = RocketExpoPlayerDelegate(parentViewController: pvc, eventDelegate: eventDelegate) {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
        self.player = RocketPlayer.init(player: pv, hostname: self.hostname, delegate: delegate)
        self.player!.play(slug: self.slug, token: self.token) { maybeError in
            switch maybeError {
            case .none:
                RocketExpoModule.loggerDelegate.info(message: "\(String(describing: Self.self)) playback started")
                break
            case let .some(error):
                RocketExpoModule.loggerDelegate.error(message: "\(String(describing: Self.self)) error starting playback \(error.type): \(error.message)")
                self.eventDelegate.onErrorPlaybackAborted(type: "generic")
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
                break
            }
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.playerView?.pause()
        self.playerView?.replaceCurrentItem(with: nil)
        self.player = nil
        self.eventDelegate.onFullscreenPlayerClosed()
    }
}
