import RocketExpo, { RocketExpoPlaybackAbortError, RocketExpoPlaybackProgress, RocketExpoView } from 'rocket-expo';
import { SafeAreaView, ScrollView, Text, View, Button } from 'react-native';
import { useEffect } from 'react';

const hostname = ""
const slug = ""
const token = ""

export default function App() {
  useEffect(() => {
    RocketExpo.setupHostname(hostname);
    RocketExpo.setupLogger();
    RocketExpo.addListener('onFullscreenEnter', () => { console.log('onFullscreenEnter') })
    RocketExpo.addListener('onFullscreenExit', () => { console.log('onFullscreenExit') })
    RocketExpo.addListener('onPlayerReady', () => { console.log('onPlayerReady') })
    RocketExpo.addListener('onPlay', () => { console.log('onPlay') })
    RocketExpo.addListener('onPause', () => { console.log('onPause') })
    RocketExpo.addListener('onBuffering', () => { console.log('onBuffering') })
    RocketExpo.addListener('onProgressUpdate', (e: RocketExpoPlaybackProgress) => { console.log('onProgressUpdate ' + JSON.stringify(e)) })
    RocketExpo.addListener('onErrorPlaybackAborted', (e: RocketExpoPlaybackAbortError) => { console.log('onErrorPlaybackAborted ' + JSON.stringify(e)) })
    RocketExpo.addListener('onPlaybackCompleted', () => { console.log('onPlaybackCompleted') })
  },[]);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.container}>
        <Text style={styles.header}>Expo Rocket SDK Example</Text>
        {/*<RocketExpoView*/}
        {/*  playbackConfig={{slug: slug, token: token}}*/}
        {/*  style={styles.view}*/}
        {/*/>*/}
        <Button title="Learn More" onPress={ () => {RocketExpo.openPlayerFullscreen({slug, token})} }>
        </Button>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = {
  container: {
    flex: 1,
    backgroundColor: '#eee',
  },
  header: {
    fontSize: 30,
    margin: 20,
  },
  view: {
    flex: 1,
    height: 400,
  },
};
