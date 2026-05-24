import 'package:flutter/material.dart';
import 'leaderboard_screen.dart';
import '../services/hive_service.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  const ResultScreen({super.key, required this.score, required this.total});

  Future<void> _saveAndShowLeaderboard(BuildContext context) async {
    // shows a dialog to enter the user's name and saves the score to Hive, then navigates to the leaderboard screen
    final TextEditingController controller = TextEditingController();
    final String? name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Save Your Score'), // title of the dialog that prompts the user to save their score
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter your name', // hint text for the text field where the user enters their name
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null), // closes the dialog without saving the score if the user presses the cancel button
            child: const Text('CANCEL'), // label for the cancel button in the dialog
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()), // closes the dialog and returns the trimmed text from the controller as the user's name if they press the save button
            child: const Text('SAVE'), // label for the save button in the dialog
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      // checks if the name is not null and not empty before saving the score to Hive and navigating to the leaderboard screen
      await HiveService.addScore(name, score); // saves the user's name and score to Hive using the addScore method from HiveService
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
      }
    } else if (name != null && name.isEmpty) {
      // shows a snackbar message if the user tries to save their score without entering a name
      ScaffoldMessenger.of(context).showSnackBar(
        // shows a snackbar message if the user tries to save their score without entering a name
        const SnackBar(content: Text('Name cannot be empty')), // message displayed in the snackbar when the user tries to save their score without entering a name
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
                  '$score / $total', // displays the user's score and total questions in a large font
                  style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => _saveAndShowLeaderboard(context), // calls the _saveAndShowLeaderboard method when the user presses the button to save their score and view the leaderboard
                  icon: const Icon(Icons.leaderboard),
                  label: const Text('SAVE & LEADERBOARD'), // label for the button that saves the user's score and navigates to the leaderboard screen
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  // button that allows the user to retry the quiz by navigating back to the quiz screen
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('RETRY QUIZ'), // label for the button that allows the user to retry the quiz
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
