import type { StyleProp, ViewStyle } from 'react-native';

export type RocketExpoViewProps = {
  playbackConfig: Record<string, string>;
  onPlaybackCompleted: () => void;
  style?: StyleProp<ViewStyle>;
};
