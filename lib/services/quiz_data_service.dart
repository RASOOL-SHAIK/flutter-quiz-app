import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuizDataService {
  static Future<List<Question>> loadQuestions() async {
    final jsonString = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Question.fromJson(json)).toList();
  }

  static List<Question> getRandomQuestions(List<Question> all, int count) {
    final shuffled = List<Question>.from(all)..shuffle();
    return shuffled.take(count).toList();
  }
}
