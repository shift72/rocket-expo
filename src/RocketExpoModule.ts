import { NativeModule, requireNativeModule } from 'expo';
import { PlaybackConfig } from './RocketExpo.types';

declare class RocketExpoModule extends NativeModule {
  setupHostname(hostname: string): void;
  setupLogger(prefix: string): void;
  openPlayerFullscreen(config: PlaybackConfig): void
}

// This call loads the native module object from the JSI.
export default requireNativeModule<RocketExpoModule>('RocketExpo');
