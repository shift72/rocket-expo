import { EventSubscription } from "expo-modules-core";
import { PlaybackConfig, RocketExpoModuleEvents, RocketExpoPlaybackAbortError, RocketExpoPlaybackProgress } from "./RocketExpo.types";
import RocketExpoModule from "./RocketExpoModule";

export function openPlayerFullscreenWithEvents(config: PlaybackConfig, events: Partial<RocketExpoModuleEvents>) {
  const listeners = [
    RocketExpoModule.addListener('onFullscreenEnter', () => { events.onFullscreenEnter?.() }),
    RocketExpoModule.addListener('onFullscreenExit', () => { events.onFullscreenExit?.() }),
    RocketExpoModule.addListener('onPlayerReady', () => { events.onPlayerReady?.() }),
    RocketExpoModule.addListener('onPlay', () => { events.onPlay?.() }),
    RocketExpoModule.addListener('onPause', () => { events.onPause?.() }),
    RocketExpoModule.addListener('onBuffering', () => { events.onBuffering?.() }),
    RocketExpoModule.addListener('onProgressUpdate', (e: RocketExpoPlaybackProgress) => { events.onProgressUpdate?.(e) }),
    RocketExpoModule.addListener('onErrorPlaybackAborted', (e: RocketExpoPlaybackAbortError) => { events.onErrorPlaybackAborted?.(e) }),
    RocketExpoModule.addListener('onUserPlaybackAborted', () => { events.onUserPlaybackAborted?.() }),
    RocketExpoModule.addListener('onPlaybackCompleted', () => { events.onPlaybackCompleted?.() }),
  ]
  let cleanupListener: EventSubscription
  cleanupListener = RocketExpoModule.addListener('onFullscreenExit', () => {
    listeners.forEach(l => l.remove())
    cleanupListener?.remove()
  })
  RocketExpoModule.openPlayerFullscreen(config)
}