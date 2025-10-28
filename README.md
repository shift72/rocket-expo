# Rocket SDK Expo edition

This is a thin wrapper over the Shift72 [`rocket-sdk-android`](https://github.com/shift72/rocket-sdk-android) and [`rocket-sdk-ios`](https://github.com/shift72/rocket-sdk-ios) native SDKs, easing use of them within Expo projects.

## Get started

1. Install dependencies
```bash
npm install git://github.com/shift72/rocket-expo.git
```

2. Add the plugin to app.json
```js
{
  "expo": {
    "plugins": [
      "rocket-expo"
    ]
  }
}
```

3. Run a prebuild
```bash
npx expo prebuild --clean
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
```bash
npx expo run:android --device
```
### iOS
```bash
npx expo run:ios --device
```

## Notes
- 