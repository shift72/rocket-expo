import { NativeModule, requireNativeModule } from 'expo';

import { RocketExpoModuleEvents } from './RocketExpo.types';

declare class RocketExpoModule extends NativeModule<RocketExpoModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<RocketExpoModule>('RocketExpo');
