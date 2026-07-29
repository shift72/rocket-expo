const { withDangerousMod } = require('expo/config-plugins');
const fs = require('fs');
const path = require('path');

/**
 * rocket-expo (v0.6.1) ships Shift72RocketSDK.framework, a prebuilt DYNAMIC
 * framework with a hard LC_LOAD_DYLIB on @rpath/GoogleCast.framework/GoogleCast.
 * It therefore needs a DYNAMIC GoogleCast.framework embedded in the app bundle.
 *
 * The trunk `google-cast-sdk` pod (every release since 4.3.1) vends only the
 * STATIC GoogleCast.framework, which links into the main binary and is never
 * embedded as a framework -> the app crashes at launch with:
 *   "Library not loaded: @rpath/GoogleCast.framework/GoogleCast"
 *
 * This plugin overrides that dependency with a local podspec that points at
 * Google's official _dynamic distribution of the same version, so pod install
 * embeds a real dynamic GoogleCast.framework. Injected after `use_expo_modules!`
 * so it survives `expo prebuild --clean`.
 */
const POD_MARKER = 'google-cast-sdk.podspec.json';
const POD_LINE =
  "  pod 'google-cast-sdk', :podspec => '../google-cast-sdk.podspec.json' # dynamic GoogleCast for rocket-expo (see plugins/withGoogleCastDynamic.js)";

module.exports = function withGoogleCastDynamic(config) {
  return withDangerousMod(config, [
    'ios',
    (config) => {
      const podfilePath = path.join(
        config.modRequest.platformProjectRoot,
        'Podfile'
      );
      let contents = fs.readFileSync(podfilePath, 'utf8');

      if (!contents.includes(POD_MARKER)) {
        const updated = contents.replace(
          /(\n[ \t]*use_expo_modules!\s*\n)/,
          `$1${POD_LINE}\n`
        );
        if (updated === contents) {
          throw new Error(
            'withGoogleCastDynamic: could not find `use_expo_modules!` anchor in the Podfile to inject the google-cast-sdk override.'
          );
        }
        fs.writeFileSync(podfilePath, updated);
      }

      return config;
    },
  ]);
};
