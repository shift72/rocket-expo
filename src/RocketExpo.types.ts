import type { StyleProp, ViewStyle } from 'react-native';

export type OnLoadEventPayload = {
  url: string;
};

export type RocketExpoModuleEvents = {
  onChange: (params: ChangeEventPayload) => void;
};

export type ChangeEventPayload = {
  value: string;
};

export type RocketExpoViewProps = {
  playback_config: Record<string, string>;
//  onLoad: (event: { nativeEvent: OnLoadEventPayload }) => void;
  onPlaybackCompleted: () => void;
  style?: StyleProp<ViewStyle>;
};
