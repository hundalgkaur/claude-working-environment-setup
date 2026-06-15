import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View } from "react-native";

export default function App() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>crossplatform-app-starter</Text>
      <Text style={styles.subtitle}>iOS · Android · Web — one React Native codebase</Text>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#fff",
    padding: 24,
  },
  title: {
    fontSize: 22,
    fontWeight: "600",
  },
  subtitle: {
    marginTop: 8,
    fontSize: 14,
    color: "#555",
    textAlign: "center",
  },
});
