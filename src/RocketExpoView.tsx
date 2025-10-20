import { requireNativeView } from 'expo';
import * as React from 'react';

import { RocketExpoViewProps } from './RocketExpo.types';

const NativeView: React.ComponentType<RocketExpoViewProps> =
  requireNativeView('RocketExpo');

export default function RocketExpoView(props: RocketExpoViewProps) {
  return <NativeView {...props} />;
}
