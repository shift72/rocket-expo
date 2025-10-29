# Expo bare installation instructions

1. Install dependencies
```bash
npm install git://github.com/shift72/rocket-expo.git#v0.1.0
```

2. Add desugaring to `android/app/build.gradle`
```groovy
android {
  compileOptions {
    coreLibraryDesugaringEnabled true
    ...
  }
  ...
}

dependencies {
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
  ...
}
```

4. Run one-time initialisation somewhere in a root view
```js
import RocketExpo from 'rocket-expo';

useEffect(() => {
  RocketExpo.setupHostname(hostname);
  RocketExpo.setupLogger();
},[]);
```

5. Add a RocketExpoView somewhere
```js
import { RocketExpoView } from 'rocket-expo';

<RocketExpoView
  playbackConfig={{slug: slug, token: token}}
  onPlaybackCompleted={() => console.log("playback completed")}
  style={{
    width: '100%',
    height: 400 //for example
  }}
/>
```

6. Compile and start the app
### Android
via Android Studio or:
```bash
npx expo run:android --device
```
### iOS
via Xcode or:
```bash
npx expo run:ios --device
```