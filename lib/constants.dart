import 'package:flutter/material.dart';

class AppConstants {
  // ========== STRINGS ==========
  static const String appTitle = 'Quiz Challenge';
  static const String designedBy = 'Designed by Rasool Shaik';
  static const String presentedBy = 'Presented by Aapthi Technologies';
  static const String settingsTitle = 'Settings';
  static const String soundEffects = 'Sound Effects';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsConditions = 'Terms & Conditions';
  static const String rateApp = 'Rate App';
  static const String leaderboardTitle = 'Leaderboard';
  static const String noScoresYet = 'No scores yet';
  static const String saveYourScore = 'Save Your Score';
  static const String enterNameHint = 'Enter your name';
  static const String cancel = 'CANCEL';
  static const String save = 'SAVE';
  static const String nameCannotBeEmpty = 'Name cannot be empty';
  static const String yourScore = 'Your Score';
  static const String quizCompleted = 'Quiz Completed';
  static const String saveAndLeaderboard = 'SAVE & LEADERBOARD';
  static const String retryQuiz = 'RETRY QUIZ';
  static const String nextQuestion = 'NEXT QUESTION ➡';
  static const String attemptedLabel = '✅ Attempted';
  static const String unansweredLabel = '⏳ Unanswered';
  static const String correctLabel = '✔️ Correct';
  static const String wrongLabel = '❌ Wrong';
  static const String pointsUnit = 'pts';
  static const String secondsUnit = 'sec';
  static const String privacyPolicyText = 'We do not collect any personal data. Your scores are stored locally.';

  // ========== DURATIONS ==========
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration timerInterval = Duration(seconds: 1);
  static const Duration answerFeedbackDelay = Duration(milliseconds: 800);
  static const int defaultTimerSeconds = 30;

  // ========== SIZES & SPACINGS ==========
  static const double splashLogoSize = 100;
  static const double appBarElevation = 0;
  static const double defaultBorderRadius = 16.0;
  static const double progressBarHeight = 8;
  static const double timerIconSize = 24;
  static const double questionFontSize = 24;
  static const double optionFontSize = 16;
  static const double buttonHeight = 56;
  static const double buttonFontSize = 18;
  static const double resultScoreFontSize = 52;
  static const double resultSubtitleFontSize = 28;
  static const double resultBreakdownFontSize = 16;

  // ========== PADDINGS & MARGINS ==========
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double extraSmallPadding = 6.0;

  // ========== COLORS (MaterialColor for shade access) ==========
  static const MaterialColor correctColor = Colors.green;
  static const MaterialColor wrongColor = Colors.red;
  static const Color warningColor = Colors.amber;
  static const Color timerWarningColor = Colors.deepOrange;
}
