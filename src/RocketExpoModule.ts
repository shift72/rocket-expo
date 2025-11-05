import { NativeModule, requireNativeModule } from 'expo';

declare class RocketExpoModule extends NativeModule {
  setupHostname(hostname: string): void;
  setupLogger(prefix: string): void;
  openPlayerFullscreen(config: {slug: string, token: string}): void
}

// This call loads the native module object from the JSI.
export default requireNativeModule<RocketExpoModule>('RocketExpo');
