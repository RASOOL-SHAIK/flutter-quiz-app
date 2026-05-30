import 'package:flutter/material.dart';
import '../constants.dart';
import 'leaderboard_screen.dart';
import '../services/hive_service.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final int attemptedCount;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.attemptedCount,
  });

  Future<void> _saveAndShowLeaderboard(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius)),
        title: Text(AppConstants.saveYourScore),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: AppConstants.enterNameHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: Text(AppConstants.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(AppConstants.save),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await HiveService.addScore(name, score);
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
      }
    } else if (name != null && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppConstants.nameCannotBeEmpty)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final unanswered = total - attemptedCount;
    final wrong = attemptedCount - score;
    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.quizCompleted), centerTitle: true),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.primaryColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05, horizontal: AppConstants.largePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 80, color: theme.primaryColor),
                const SizedBox(height: AppConstants.largePadding),
                Text(
                  AppConstants.yourScore,
                  style: theme.textTheme.headlineSmall?.copyWith(color: Colors.grey.shade700),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  '$score / $total',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                    fontSize: AppConstants.resultScoreFontSize,
                  ),
                ),
                const SizedBox(height: AppConstants.largePadding),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius)),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      children: [
                        _buildRow(AppConstants.attemptedLabel, '$attemptedCount / $total', theme.primaryColor, theme),
                        const Divider(),
                        _buildRow(AppConstants.unansweredLabel, '$unanswered / $total', AppConstants.warningColor, theme),
                        const Divider(),
                        _buildRow(AppConstants.correctLabel, '$score', AppConstants.correctColor, theme),
                        const Divider(),
                        _buildRow(AppConstants.wrongLabel, '$wrong', AppConstants.wrongColor, theme),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.largePadding * 2),
                ElevatedButton.icon(
                  onPressed: () => _saveAndShowLeaderboard(context),
                  icon: const Icon(Icons.leaderboard),
                  label: Text(AppConstants.saveAndLeaderboard),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, AppConstants.buttonHeight)),
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(AppConstants.retryQuiz),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, AppConstants.buttonHeight)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
