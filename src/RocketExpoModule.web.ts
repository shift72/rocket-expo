import { registerWebModule, NativeModule } from 'expo';

import { RocketExpoModuleEvents } from './RocketExpo.types';

class RocketExpoModule extends NativeModule<RocketExpoModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
}

export default registerWebModule(RocketExpoModule, 'RocketExpoModule');
