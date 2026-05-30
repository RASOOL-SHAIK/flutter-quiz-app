import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/hive_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> _scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final scores = await HiveService.getTopScores();
    setState(() => _scores = scores);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.leaderboardTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: AppConstants.appBarElevation,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.primaryColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: _scores.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.leaderboard, size: 80, color: Colors.grey),
                    SizedBox(height: AppConstants.defaultPadding),
                    Text(AppConstants.noScoresYet, style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
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
                    rankColor = theme.primaryColor.withOpacity(0.7);
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: rankColor,
                        child: Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(
                        _scores[i]['name'],
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding, vertical: AppConstants.extraSmallPadding),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                        ),
                        child: Text(
                          '${_scores[i]['score']} ${AppConstants.pointsUnit}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
