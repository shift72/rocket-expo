import ExpoModulesCore
import AVKit
import SwiftUI
import AVFoundation
import Shift72RocketSDK

class RocketExpoView: ExpoView {
    let playerViewController = AVPlayerViewController()
    let playerView = AVPlayer()
    
    var player: RocketPlayer?
    
    let onPlaybackCompleted = EventDispatcher()
    
    public override var bounds: CGRect {
      didSet {
        playerViewController.view.frame = self.bounds
      }
    }
    
    static var hostname: String = ""

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        clipsToBounds = true
        playerViewController.player = playerView
        playerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(playerViewController.view)
        
        let delegate = RocketExpoPlayerDelegate(parentViewController: playerViewController, onComplete: {
            self.onPlaybackCompleted([:])
        })
        if RocketExpoView.hostname.isEmpty {
            appContext?.jsLogger.fatal("hostname must be set before initialising RocketExpoView")
        }
        self.player = RocketPlayer.init(player: self.playerView, hostname: RocketExpoView.hostname, delegate: delegate)
    }
}