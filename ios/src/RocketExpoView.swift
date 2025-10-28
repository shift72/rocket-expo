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
        
        let delegate = RocketExpoPlayerDelegate(parentViewController: playerViewController, onComplete: {
            self.onPlaybackCompleted([:])
        })
        if RocketExpoView.hostname.isEmpty {
            appContext?.jsLogger.fatal("hostname must be set before initialising RocketExpoView")
        }
        self.player = RocketPlayer.init(player: self.playerView, hostname: RocketExpoView.hostname, delegate: delegate)
        
        addSubview(playerViewController.view)
    }

    public override func didMoveToWindow() {
      // TV is doing a normal view controller present, so we should not execute
      // this code
      #if !os(tvOS)
      playerViewController.beginAppearanceTransition(self.window != nil, animated: true)
      #endif
    }
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            DispatchQueue.main.async { [playerView] in
                playerView.replaceCurrentItem(with: nil)
            }
        }
    }
    
    public override func safeAreaInsetsDidChange() {
      super.safeAreaInsetsDidChange()
      playerViewController.view.removeFromSuperview()
      addSubview(playerViewController.view)
    }
}
