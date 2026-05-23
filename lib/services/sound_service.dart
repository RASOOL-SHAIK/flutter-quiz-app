import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  static bool isEnabled = true;

  static void setEnabled(bool enabled) {
    isEnabled = enabled;
  }

  static Future<void> playCorrect() async {
    if (!isEnabled) return;
    try {
      await _player.play(AssetSource('sounds/correct.ogg'));
    } catch (e) {
      // ignore missing file
    }
  }

  static Future<void> playWrong() async {
    if (!isEnabled) return;
    try {
      await _player.play(AssetSource('sounds/wrong.ogg'));
    } catch (e) {
      // ignore missing file
    }
  }
}
