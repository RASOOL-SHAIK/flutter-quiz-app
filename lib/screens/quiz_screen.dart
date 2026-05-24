import 'dart:async';
import 'package:flutter/material.dart';
import '../services/quiz_data_service.dart';
import '../services/sound_service.dart';
import '../models/question.dart';
import 'result_screen.dart';
import 'settings_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _roundQuestions = [];
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  Timer? _timer;
  int _timeLeft = 30;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final all = await QuizDataService.loadQuestions();
    setState(() {
      _roundQuestions = QuizDataService.getRandomQuestions(all, 10);
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft <= 1) {
        timer.cancel();
        if (!_isAnswered) _nextQuestion(autoTimeOut: true);
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _checkAnswer(int selectedIdx) {
    if (_isAnswered) return;
    setState(() {
      _isAnswered = true;
      _selectedAnswerIndex = selectedIdx;
      final isCorrect = _roundQuestions[_currentIndex].answers[selectedIdx] == _roundQuestions[_currentIndex].correctAnswer;
      if (isCorrect) {
        _score++;
        SoundService.playCorrect();
      } else {
        SoundService.playWrong();
      }
      _timer?.cancel();
      Future.delayed(const Duration(milliseconds: 800), () => _nextQuestion());
    });
  }

  void _nextQuestion({bool autoTimeOut = false}) {
    if (_currentIndex + 1 < _roundQuestions.length) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null; // reset selected answer
        _isAnswered = false; // reset answered state
        _startTimer(); // again restart timer for next question
      });
    } else {
      // quiz end
      _timer?.cancel(); // stop timer if still running
      Navigator.pushReplacement(
          // navigate to result screen and pass score & push replacement means user can't go back to quiz screen
          context,
          MaterialPageRoute(
              // materialpageroute means ? what ? it is used to navigate to another screen with material design transition
              // why builder ? what is builder ? simply it is a function that returns a widget and it is used to build the widget tree for the new screen
              builder: (_) => ResultScreen(
                  // result screen is a stateless widget that shows the final score and some message based on the score
                  score: _score,
                  total: _roundQuestions.length)));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_roundQuestions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final q = _roundQuestions[_currentIndex];
    final timerProgress = _timeLeft / 30;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Challenge'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Question progress bar (teal)
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / _roundQuestions.length,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
                const SizedBox(height: 12),
                // Timer bar with icon (amber / deep orange)
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.deepOrange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: timerProgress,
                        backgroundColor: Colors.grey.shade300,
                        color: timerProgress > 0.3 ? Colors.amber.shade700 : Colors.deepOrange,
                        borderRadius: BorderRadius.circular(8),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_timeLeft sec',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Question text
                Text(
                  q.text,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Options as beautiful cards with correct/wrong highlighting
                ...List.generate(q.answers.length, (idx) {
                  Color? cardColor = Colors.white;
                  Color borderColor = Colors.grey.shade300;
                  Color textColor = Colors.black87;
                  if (_isAnswered && idx == _selectedAnswerIndex) {
                    final isUserCorrect = q.answers[idx] == q.correctAnswer;
                    cardColor = isUserCorrect ? Colors.green.shade50 : Colors.red.shade50;
                    borderColor = isUserCorrect ? Colors.green : Colors.red;
                    textColor = isUserCorrect ? Colors.green.shade800 : Colors.red.shade800;
                  } else if (_isAnswered && q.answers[idx] == q.correctAnswer) {
                    cardColor = Colors.green.shade50;
                    borderColor = Colors.green;
                    textColor = Colors.green.shade800;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(16),
                      color: cardColor,
                      child: InkWell(
                        onTap: _isAnswered ? null : () => _checkAnswer(idx),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor, width: 1.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: _isAnswered
                                ? Icon(
                                    q.answers[idx] == q.correctAnswer ? Icons.check_circle : (idx == _selectedAnswerIndex ? Icons.cancel : Icons.radio_button_unchecked),
                                    color: q.answers[idx] == q.correctAnswer ? Colors.green : (idx == _selectedAnswerIndex ? Colors.red : Colors.grey),
                                  )
                                : Radio<int>(
                                    value: idx,
                                    groupValue: _selectedAnswerIndex,
                                    onChanged: (value) => _checkAnswer(value!),
                                    activeColor: Colors.blue,
                                  ),
                            title: Text(
                              q.answers[idx],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                // Stylish Next button
                ElevatedButton(
                  onPressed: _isAnswered ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: _isAnswered ? Colors.teal : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    elevation: 6,
                  ),
                  child: const Text(
                    'NEXT QUESTION ➡',
                    style: TextStyle(fontSize: 18, letterSpacing: 1.2),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
