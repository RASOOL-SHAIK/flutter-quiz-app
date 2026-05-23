class Question {
  final String text;
  final List<String> answers;
  final String correctAnswer;

  Question(
      {required this.text, required this.answers, required this.correctAnswer});
 
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['question'],
      answers: List<String>.from(json['answers']),
      correctAnswer: json['correct_answer'],
    );
  }
}
