import * as React from 'react';

import { RocketExpoViewProps } from './RocketExpo.types';

export default function RocketExpoView(props: RocketExpoViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
