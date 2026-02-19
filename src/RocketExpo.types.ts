import type { StyleProp, ViewStyle } from 'react-native';

export type PlaybackConfig = {
  slug: string,
  token: string
}

export type RocketExpoViewProps = {
  playbackConfig: PlaybackConfig;
  style?: StyleProp<ViewStyle>;
}

export type RocketExpoModuleEvents = {

  onFullscreenEnter(): void;

  onFullscreenExit(): void;

  onPlayerReady(): void;

  onPlay(): void;

  onPause(): void;

  onBuffering(): void;

  onProgressUpdate(event: RocketExpoPlaybackProgress): void;

  onErrorPlaybackAborted(event: RocketExpoPlaybackAbortError): void;

  onPlaybackCompleted(): void;
}

export type RocketExpoPlaybackProgress = {
  elapsedSeconds: number,
  runtimeSeconds: number
}

export type RocketExpoPlaybackAbortError = {
  type: string,
  message: string
}