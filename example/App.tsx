import { useEvent } from 'expo';
import RocketExpo, { RocketExpoView } from 'rocket-expo';
import { SafeAreaView, ScrollView, Text, View } from 'react-native';
import { useEffect } from 'react';

const hostname = ""
const slug = ""
const token = ""

export default function App() {
  useEffect(() => {
    RocketExpo.setupHostname(hostname);
    RocketExpo.setupLogger("RocketExpo");
  },[]);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.container}>
        <Text style={styles.header}>Expo Rocket SDK Example</Text>
        <RocketExpoView
          playbackConfig={{slug: slug, token: token}}
          onPlaybackCompleted={() => console.log("onPlaybackCompleted boi")}
          style={styles.view}
        />
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
