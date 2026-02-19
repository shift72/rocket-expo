import ExpoModulesCore
import Shift72RocketSDK

fileprivate let FULLSCREEN_ENTER_EVENT_NAME = "onFullscreenEnter"
fileprivate let FULLSCREEN_EXIT_EVENT_NAME = "onFullscreenExit"
fileprivate let PLAYER_READY_EVENT_NAME = "onPlayerReady"
fileprivate let PLAY_EVENT_NAME = "onPlay"
fileprivate let PAUSE_EVENT_NAME = "onPause"
fileprivate let BUFFERING_EVENT_NAME = "onBuffering"
fileprivate let PROGRESS_UPDATE_EVENT_NAME = "onProgressUpdate"
fileprivate let ERROR_PLAYBACK_ABORTED_EVENT_NAME = "onErrorPlaybackAborted"
fileprivate let PLAYBACK_COMPLETED_EVENT_NAME = "onPlaybackCompleted"

class RocketExpoEventsDelegate {
    static let EventList = [
        FULLSCREEN_ENTER_EVENT_NAME,
        FULLSCREEN_EXIT_EVENT_NAME,
        PLAYER_READY_EVENT_NAME,
        PLAY_EVENT_NAME,
        PAUSE_EVENT_NAME,
        BUFFERING_EVENT_NAME,
        PROGRESS_UPDATE_EVENT_NAME,
        ERROR_PLAYBACK_ABORTED_EVENT_NAME,
        PLAYBACK_COMPLETED_EVENT_NAME,
    ]
    
    private let appContext: AppContext
    
    private var playPauseState: PlayPauseState = .Paused
    private var bufferingState: BufferingState = .Buffering
    private var lastStateEvent: String = ""
    
    init(appContext: AppContext) {
        self.appContext = appContext
    }
    
    public func onFullscreenPlayerOpened() {
        sendEvent(FULLSCREEN_ENTER_EVENT_NAME)
    }
    
    public func onFullscreenPlayerClosed() {
        sendEvent(FULLSCREEN_EXIT_EVENT_NAME)
    }
    
    public func onPlaybackStarted() {
        sendEvent(PLAYER_READY_EVENT_NAME)
    }
    
    public func onPlayPauseChanged(newState: PlayPauseState) {
        if newState != self.playPauseState {
            self.playPauseState = newState
            resolvePlayBuffering()
        }
    }
    
    public func onBufferingStateChanged(newState: BufferingState) {
        if newState != self.bufferingState {
            self.bufferingState = newState
            resolvePlayBuffering()
        }
    }
    
    public func onProgressUpdate(elapsedSeconds: Double, runtimeSeconds: Double) {
        sendEvent(PROGRESS_UPDATE_EVENT_NAME, [
            "elapsedSeconds": elapsedSeconds,
            "runtimeSeconds": runtimeSeconds
        ])
    }
    
    public func onPlaybackCompleted() {
        sendEvent(PLAYBACK_COMPLETED_EVENT_NAME)
    }
    
    public func onErrorPlaybackAborted(type: String) {
        sendEvent(ERROR_PLAYBACK_ABORTED_EVENT_NAME, [
            "type": type
        ])
    }
    
    private func resolvePlayBuffering() {
        switch (self.bufferingState, self.playPauseState) {
        case (.Buffering, _):
            sendStateEvent(BUFFERING_EVENT_NAME)
        case (_, .Playing):
            sendStateEvent(PLAY_EVENT_NAME)
        case (_, .Paused):
            sendStateEvent(PAUSE_EVENT_NAME)
        }
    }
    
    private func sendStateEvent(_ eventName: String) {
        if lastStateEvent != eventName {
            sendEvent(eventName)
            lastStateEvent = eventName
        }
    }
    
    //copied from ExpoModulesCore
    private func sendEvent(_ eventName: String, _ body: [String: Any?] = [:]) {
      appContext.eventEmitter?.sendEvent(withName: eventName, body: body)
    }
}
