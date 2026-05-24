import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key}); // this line - defines the constructor for the LeaderboardScreen widget, which is a StatefulWidget that displays the leaderboard of top scores saved in Hive.

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState(); // this line - creates the mutable state for the LeaderboardScreen widget by returning an instance of _LeaderboardScreenState, which is defined below and contains the logic for loading and displaying the scores from Hive.
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> _scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    // this method - loads the top scores from Hive using the HiveService and updates the state to display them in the UI
    final scores = await HiveService.getTopScores(); // retrieves the top scores from Hive using the getTopScores method from HiveService, which returns a list of maps containing the name and score of each entry
    setState(() => _scores = scores); // updates the state of the widget by setting the _scores variable to the list of scores retrieved from Hive, which triggers a rebuild of the UI to display the updated leaderboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: _scores.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.leaderboard, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No scores yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _scores.length,
                itemBuilder: (ctx, i) {
                  final rank = i + 1;
                  Color rankColor;
                  if (rank == 1)
                    rankColor = Colors.amber;
                  else if (rank == 2)
                    rankColor = Colors.grey.shade600;
                  else if (rank == 3)
                    rankColor = Colors.brown.shade400;
                  else
                    rankColor = Colors.blue.shade300;
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: rankColor,
                        child: Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(
                        _scores[i]['name'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_scores[i]['score']} pts',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
