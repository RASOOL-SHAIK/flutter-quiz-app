import 'package:flutter/material.dart';
import 'leaderboard_screen.dart';
import '../services/hive_service.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  const ResultScreen({super.key, required this.score, required this.total});

  Future<void> _saveAndShowLeaderboard(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final String? name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Save Your Score'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await HiveService.addScore(name, score);
      if (context.mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
      }
    } else if (name != null && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Completed'), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                const SizedBox(height: 20),
                Text(
                  'Your Score',
                  style: TextStyle(fontSize: 28, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Text(
                  '$score / $total',
                  style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => _saveAndShowLeaderboard(context),
                  icon: const Icon(Icons.leaderboard),
                  label: const Text('SAVE & LEADERBOARD'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56)),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const QuizScreen()));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('RETRY QUIZ'),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
