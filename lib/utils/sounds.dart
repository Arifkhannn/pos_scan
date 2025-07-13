import 'package:audioplayers/audioplayers.dart';

class Sounds {
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playBeepSound() async {
    try {
      await audioPlayer.play(AssetSource('beep.mp3'), volume: 1.0);
    } catch (e) {
      print("Error playing beep sound: $e");
    }
  }

  Future<void> playWelcomeSound() async {
    try {
      await audioPlayer.play(AssetSource('auctech.mp3'), volume: 1.0);
    } catch (e) {
      print("Error playing welcome sound: $e");
    }
  }

  Future<void> playWrongSound() async {
    try {
      await audioPlayer.play(AssetSource('wrong.mp3'), volume: 1.0);
    } catch (e) {
      print("Error playing wrong sound: $e");
    }
  }
}
