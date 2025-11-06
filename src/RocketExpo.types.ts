import type { StyleProp, ViewStyle } from 'react-native';

export type PlaybackConfig = {
  slug: string,
  token: string
}

export type RocketExpoViewProps = {
  playbackConfig: PlaybackConfig;
  onPlaybackCompleted: () => void;
  style?: StyleProp<ViewStyle>;
}
