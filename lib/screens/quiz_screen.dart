import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/quiz_data_service.dart';
import '../services/sound_service.dart';
import '../models/question.dart';
import 'result_screen.dart';
import 'settings_screen.dart';

// Timer bar widget – rebuilds only itself every second
class _TimerBar extends StatefulWidget {
  final VoidCallback onTimeout;
  const _TimerBar({super.key, required this.onTimeout});

  @override
  State<_TimerBar> createState() => _TimerBarState();
}

class _TimerBarState extends State<_TimerBar> {
  int _timeLeft = AppConstants.defaultTimerSeconds;
  Timer? _timer;
  bool _isActive = true;

  void startTimer() {
    _timer?.cancel();
    _timeLeft = AppConstants.defaultTimerSeconds;
    _isActive = true;
    _timer = Timer.periodic(AppConstants.timerInterval, (timer) {
      if (_timeLeft <= 1) {
        timer.cancel();
        if (_isActive) widget.onTimeout();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void stopTimer() {
    _isActive = false;
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProgress = _timeLeft / AppConstants.defaultTimerSeconds;
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.timer, color: theme.primaryColor, size: AppConstants.timerIconSize),
        const SizedBox(width: AppConstants.smallPadding),
        Expanded(
          child: LinearProgressIndicator(
            value: timerProgress,
            backgroundColor: Colors.grey.shade300,
            color: timerProgress > 0.3 ? AppConstants.warningColor : AppConstants.timerWarningColor,
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius / 2),
            minHeight: AppConstants.progressBarHeight,
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        Text(
          '$_timeLeft ${AppConstants.secondsUnit}',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
      ],
    );
  }
}

// Main Quiz Screen
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _roundQuestions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _attemptedCount = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  final GlobalKey<_TimerBarState> _timerBarKey = GlobalKey<_TimerBarState>();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final all = await QuizDataService.loadQuestions();
    setState(() {
      _roundQuestions = QuizDataService.getRandomQuestions(all, 10);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timerBarKey.currentState?.startTimer();
    });
  }

  void _checkAnswer(int selectedIdx) {
    if (_isAnswered) return;
    setState(() {
      _isAnswered = true;
      _selectedAnswerIndex = selectedIdx;
      _attemptedCount++;
      final isCorrect = _roundQuestions[_currentIndex].answers[selectedIdx] == _roundQuestions[_currentIndex].correctAnswer;
      if (isCorrect) {
        _score++;
        SoundService.playCorrect();
      } else {
        SoundService.playWrong();
      }
      _timerBarKey.currentState?.stopTimer();
      Future.delayed(AppConstants.answerFeedbackDelay, () => _nextQuestion());
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 < _roundQuestions.length) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
      _timerBarKey.currentState?.startTimer();
    } else {
      _timerBarKey.currentState?.stopTimer();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            score: _score,
            total: _roundQuestions.length,
            attemptedCount: _attemptedCount,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timerBarKey.currentState?.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_roundQuestions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final q = _roundQuestions[_currentIndex];
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
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
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / _roundQuestions.length,
                  backgroundColor: Colors.grey.shade300,
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius / 2),
                  minHeight: AppConstants.progressBarHeight,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                _TimerBar(key: _timerBarKey, onTimeout: _nextQuestion),
                const SizedBox(height: AppConstants.defaultPadding * 2),
                Text(
                  q.text,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: AppConstants.questionFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.largePadding * 2),
                ...List.generate(q.answers.length, (idx) {
                  Color? cardColor = Colors.white;
                  Color borderColor = Colors.grey.shade300;
                  Color textColor = Colors.black87;
                  if (_isAnswered && idx == _selectedAnswerIndex) {
                    final isUserCorrect = q.answers[idx] == q.correctAnswer;
                    cardColor = isUserCorrect ? AppConstants.correctColor.withOpacity(0.1) : AppConstants.wrongColor.withOpacity(0.1);
                    borderColor = isUserCorrect ? AppConstants.correctColor : AppConstants.wrongColor;
                    textColor = isUserCorrect ? AppConstants.correctColor.shade800 : AppConstants.wrongColor.shade800;
                  } else if (_isAnswered && q.answers[idx] == q.correctAnswer) {
                    cardColor = AppConstants.correctColor.withOpacity(0.1);
                    borderColor = AppConstants.correctColor;
                    textColor = AppConstants.correctColor.shade800;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      color: cardColor,
                      child: InkWell(
                        onTap: _isAnswered ? null : () => _checkAnswer(idx),
                        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor, width: 1.5),
                            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                          ),
                          child: ListTile(
                            leading: _isAnswered
                                ? Icon(
                                    q.answers[idx] == q.correctAnswer ? Icons.check_circle : (idx == _selectedAnswerIndex ? Icons.cancel : Icons.radio_button_unchecked),
                                    color: q.answers[idx] == q.correctAnswer ? AppConstants.correctColor : (idx == _selectedAnswerIndex ? AppConstants.wrongColor : Colors.grey),
                                  )
                                : Radio<int>(
                                    value: idx,
                                    groupValue: _selectedAnswerIndex,
                                    onChanged: (value) => _checkAnswer(value!),
                                    activeColor: theme.primaryColor,
                                  ),
                            title: Text(
                              q.answers[idx],
                              style: TextStyle(
                                fontSize: AppConstants.optionFontSize,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isAnswered ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.8, AppConstants.buttonHeight),
                    backgroundColor: _isAnswered ? theme.primaryColor : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    elevation: 6,
                  ),
                  child: Text(
                    AppConstants.nextQuestion,
                    style: const TextStyle(fontSize: AppConstants.buttonFontSize, letterSpacing: 1.2),
                  ),
                ),
                const SizedBox(height: AppConstants.defaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
