//
//  RocketExpoPlayerDelegate.swift
//  Shift72RocketSDKExpo
//
//  Created by Declan ter Veer-Burke on 24/10/2025.
//

import Shift72RocketSDK

public class RocketExpoPlayerDelegate: RocketPlayerDelegate {
    private weak var parentViewController: UIViewController?
    private var eventDelegate: RocketExpoEventsDelegate
    private var onComplete: () -> Void
    
    init(parentViewController: UIViewController, eventDelegate: RocketExpoEventsDelegate, onComplete: @escaping () -> Void) {
        self.parentViewController = parentViewController
        self.eventDelegate = eventDelegate
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
                self.eventDelegate.onErrorPlaybackAborted(type: "too_many_devices")
                self.onComplete()
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func onTooManyConcurrentStreamsPlaybackAborted() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Too Many Concurrent Streams", message: "Your account is currently being used by too many other devices or browsers.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.eventDelegate.onErrorPlaybackAborted(type: "too_many_streams")
                self.onComplete()
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func onPlaybackStarted() {
        self.eventDelegate.onPlaybackStarted()
    }
    
    public func onPlayPauseChanged(newState: PlayPauseState) {
        self.eventDelegate.onPlayPauseChanged(newState: newState)
    }
    
    public func onBufferingStateChanged(newState: BufferingState) {
        self.eventDelegate.onBufferingStateChanged(newState: newState)
    }
    
    public func onPlaybackCompleted(reason: PlaybackCompletionReason) {
        if reason == .ReachedEnd {
            self.eventDelegate.onPlaybackCompleted()
        }
        self.onComplete()
    }
    
    public func onErrorPlaybackAborted() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Playback Aborted", message: "Something went wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.eventDelegate.onErrorPlaybackAborted(type: "generic")
                self.onComplete()
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func onAuthorizationErrorPlaybackAborted() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Authorisation Error", message: "Authorisation is not valid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.eventDelegate.onErrorPlaybackAborted(type: "authorization")
                self.onComplete()
            }))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func onVideoSizeChanged(width: Double, height: Double) {
        // nothing
    }
    
    public func onProgressUpdate(elapsedSeconds: Double, runtimeSeconds: Double) {
        self.eventDelegate.onProgressUpdate(elapsedSeconds: elapsedSeconds, runtimeSeconds: runtimeSeconds)
    }
}
