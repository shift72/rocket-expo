//
//  RocketExpoPlayerViewController.swift
//  Shift72RocketSDKExample
//
//  Created by Declan ter Veer-Burke on 06/11/2025.
//

import UIKit
import AVKit
import Shift72RocketSDK

class RocketExpoPlayerViewController: UIViewController {
    private var playerViewController: AVPlayerViewController!
    private var playerView: AVPlayer!
    private var player: RocketPlayer?
    let hostname: String
    let slug: String
    let token: String
    
    init(hostname: String, slug: String, token: String) {
        self.hostname = hostname
        self.slug = slug
        self.token = token
        
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
        self.playerViewController = AVPlayerViewController()
        self.playerViewController.player = playerView
        self.addChild(self.playerViewController)
        // make video view
        self.playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.playerViewController.view)
        NSLayoutConstraint.activate([
            self.playerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.playerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.playerViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            self.playerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        self.playerViewController.didMove(toParent: self)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        self.player = RocketPlayer.init(player: playerView, hostname: self.hostname, parentViewController: self)
        self.player!.play(slug: self.slug, token: self.token) { maybeError in
            switch maybeError {
            case .none:
                print("started")
                break
            case let .some(error):
                print("error", error.type, error.message)
                break
            }
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.player = nil
    }
}
