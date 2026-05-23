import 'package:hive/hive.dart';

class HiveService {
  static late Box _scoresBox;

  static Future<void> init() async {
    _scoresBox = await Hive.openBox('scores');
  }

  static Future<void> addScore(String name, int score) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString(); // now a string
    await _scoresBox.put(id, {'name': name, 'score': score});
  }

  static Future<List<Map<String, dynamic>>> getTopScores(
      {int limit = 10}) async {
    final list = _scoresBox.values
        .cast<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    list.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return list.take(limit).toList();
  }
}
