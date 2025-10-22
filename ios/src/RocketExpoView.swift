import ExpoModulesCore
import AVKit
import SwiftUI
import AVFoundation
import Shift72RocketSDK

class RocketExpoView: ExpoView {
    let playerViewController = AVPlayerViewController()
    let playerView = AVPlayer()
    let delegate = MyRocketPlayerDelegate()
    
    var player: RocketPlayer?
    
    public override var bounds: CGRect {
      didSet {
        playerViewController.view.frame = self.bounds
      }
    }
    
    let hostname = "apptvod.shift72.com"

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        clipsToBounds = true
        playerViewController.player = playerView
        playerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(playerViewController.view)
        
        self.player = RocketPlayer.init(player: self.playerView, hostname: self.hostname, delegate: self.delegate)
    }
    
    public override func safeAreaInsetsDidChange() {
      super.safeAreaInsetsDidChange()
      // This is the only way that I (@behenate) found to force re-calculation of the safe-area insets for native controls
      playerViewController.view.removeFromSuperview()
      addSubview(playerViewController.view)
    }
}

struct MyRocketPlayerDelegate: RocketPlayerDelegate{
  func onWatchWindow(timeToWatch: Int, response: @escaping (Shift72RocketSDK.WatchWindowResponse) -> Void) {
      print("player delegate onWatchWindow \(timeToWatch)")
      response(.StartWatchWindow)
  }

  func onFoundPlaybackProgress(position: Int, length: Int, response: @escaping (Shift72RocketSDK.PlaybackProgressResponse) -> Void) {
      print("player delegate onFoundPlaybackProgress \(position)/\(length)")
      response(.StartFromBeginning)
  }

  func onTooManyDevicesPlaybackAborted() {
      print("player delegate onTooManyDevicesPlaybackAborted")
  }

  func onTooManyConcurrentStreamsPlaybackAborted() {
      print("player delegate onTooManyConcurrentStreamsPlaybackAborted")
  }

  func onPlaybackStarted() {
      print("player delegate onPlaybackStarted")
  }

  func onPlaybackCompleted() {
      print("player delegate onPlaybackCompleted")
  }

  func onErrorPlaybackAborted() {
      print("player delegate onErrorPlaybackAborted")
  }

  func onAuthorizationErrorPlaybackAborted() {
      print("player delegate onAuthorizationErrorPlaybackAborted")
  }

  func videoSizeChanged(width: Double, height: Double) {
      print("player delegate videoSizeChanged \(width)x\(height)")
  }
}

