import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuizDataService {
  static Future<List<Question>> loadQuestions() async {
    final jsonString = await rootBundle.loadString('assets/questions.json'); // loads the questions.json file from the assets folder as a string
    final List<dynamic> jsonList = json.decode(jsonString); // converts json string to a list of dynamic objects of dart
    return jsonList.map((json) => Question.fromJson(json)).toList(); // maps each json object to a Question object using the fromJson factory constructor and returns a list of Question objects
    // returns to quiz_screen.dart after loading the questions and parsing them into a list of Question objects
  }

  static List<Question> getRandomQuestions(List<Question> all, int count) {
    final shuffled = List<Question>.from(all)..shuffle();
    return shuffled.take(count).toList();
  }
}
