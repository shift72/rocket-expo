import { NativeModule, requireNativeModule } from 'expo';
import { PlaybackConfig, RocketExpoModuleEvents } from './RocketExpo.types';

declare class RocketExpoModule extends NativeModule<RocketExpoModuleEvents> {
  setupHostname(hostname: string): void;
  setupLogger(): void;
  openPlayerFullscreen(config: PlaybackConfig): void
}

// This call loads the native module object from the JSI.
export default requireNativeModule<RocketExpoModule>('RocketExpo');
