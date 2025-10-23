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
    
    static var hostname = ""

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        clipsToBounds = true
        playerViewController.player = playerView
        playerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(playerViewController.view)
        
        let delegate = ExpoRocketPlayerDelegate(parentViewController: playerViewController, onComplete: {
            self.onPlaybackCompleted([:])
        })
        assert(!RocketExpoView.hostname.isEmpty, "hostname must be set before initialising RocketExpoView")
        self.player = RocketPlayer.init(player: self.playerView, hostname: RocketExpoView.hostname, delegate: delegate)
    }
    
//    public override func safeAreaInsetsDidChange() {
//      super.safeAreaInsetsDidChange()
//      playerViewController.view.removeFromSuperview()
//      addSubview(playerViewController.view)
//    }
}

public class ExpoRocketPlayerDelegate: RocketPlayerDelegate {
    private weak var parentViewController: UIViewController?
    private var onComplete: () -> Void
    
    public init(parentViewController: UIViewController, onComplete: @escaping () -> Void) {
        self.parentViewController = parentViewController
        self.onComplete = onComplete
    }
    
    public func onWatchWindow(timeToWatch: Int, response: @escaping (WatchWindowResponse) -> Void) {
        let wwHours = timeToWatch / 3600
        let wwButtonLabel = "Start Watch Window"
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Watch Window", message: "The watch window will start once you press \"\(wwButtonLabel)\" and you will have \(wwHours) hours to watch it as many times as you like.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: wwButtonLabel, style: .default, handler: { action in
                response(.StartWatchWindow)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                response(.Cancel)
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func onFoundPlaybackProgress(position: Int, length: Int, response: @escaping (PlaybackProgressResponse) -> Void) {
        let resumeHours = position / 3600
        let resumeMinutes = (position % 3600) / 60
        let resumeSeconds = position % 60
        let minutesPad = "\(resumeMinutes)".leftPadding(toLength: 2, withPad: "0")
        let secondsPad = "\(resumeSeconds)".leftPadding(toLength: 2, withPad: "0")
        let resumeTime = resumeHours > 0 ? "\(resumeHours):\(minutesPad):\(secondsPad)" : "\(resumeMinutes):\(secondsPad)"
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Resume", message: "Would you like to resume playback from \(resumeTime), or start from the beginning?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: { action in
                response(.Resume)
            }))
            alert.addAction(UIAlertAction(title: "Start From Beginning", style: .default, handler: { action in
                response(.StartFromBeginning)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                response(.Cancel)
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func onTooManyDevicesPlaybackAborted() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Too Many Devices", message: "You have reached the max number of registered devices on your account.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.onComplete()
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func onTooManyConcurrentStreamsPlaybackAborted() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Too Many Concurrent Streams", message: "Your account is currently being used by too many other devices or browsers.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.onComplete()
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func onPlaybackStarted() {
        // nothing
    }
    
    public func onPlaybackCompleted() {
        self.onComplete()
    }
    
    public func onErrorPlaybackAborted() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Playback Aborted", message: "Something went wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.onComplete()
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func onAuthorizationErrorPlaybackAborted() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Authorisation Error", message: "Authorisation is not valid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.onComplete()
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func videoSizeChanged(width: Double, height: Double) {
        // nothing
    }
}
