import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  static bool isEnabled = true;

  static void setEnabled(bool enabled) {
    isEnabled = enabled;
  }

  static Future<void> playCorrect() async {
    // plays the correct sound effect when the user selects the correct answer in the quiz screen
    if (!isEnabled) return;
    try {
      await _player.play(AssetSource('sounds/correct.ogg'));
    } catch (e) {
      // ignore missing file
    }
  }

  static Future<void> playWrong() async {
    // plays the wrong sound effect when the user selects the wrong answer in the quiz screen
    if (!isEnabled) return;
    try {
      await _player.play(AssetSource('sounds/wrong.ogg'));
    } catch (e) {
      // ignore missing file
    }
  }
}
