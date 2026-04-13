// Reexport the native module. On web, it will be resolved to RocketExpoModule.web.ts
// and on native platforms to RocketExpoModule.ts
export { default } from './RocketExpoModule';
export { default as RocketExpoView } from './RocketExpoView';
export * from './RocketExpoConvenience';
export * from './RocketExpo.types';
