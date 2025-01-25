import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/players_screen.dart';
import 'database/database_helper.dart';
import 'models/user.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'models/player.dart';
import 'models/live_score.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();

  // Insert default user
  await dbHelper.insertUser(User(email: 'operator@op.com', password: '123'));

  // Load players and live scores only if the database is empty
  await initializeData(dbHelper);

  // Check if a user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final String? loggedInUser = prefs.getString('loggedInUser');

  runApp(MyApp(initialScreen: loggedInUser == null ? LoginScreen() : PlayersScreen()));
}

Future<void> initializeData(DatabaseHelper dbHelper) async {
  // Check if players table is empty
  final players = await dbHelper.getPlayers();
  if (players.isEmpty) {
    print("Loading players data...");
    await loadPlayers(dbHelper);
  } else {
    print("Players data already initialized.");
  }

  // Check if live_scores table is empty
  final liveScores = await dbHelper.getLiveScores();
  if (liveScores.isEmpty) {
    print("Loading live scores data...");
    await loadLiveScores(dbHelper);
  } else {
    print("Live scores data already initialized.");
  }
}


Future<void> loadPlayers(DatabaseHelper dbHelper) async {
  final String response = await rootBundle.loadString('assets/data/players.json');
  final List<dynamic> playerData = json.decode(response);

  for (var player in playerData) {
    Player newPlayer = Player(
      name: player['name'],
      age: player['age'],
      dailyScore: player['total_periodic_score']['daily'],
      yearlyScore: player['total_periodic_score']['yearly'],
      bestPerformance: player['best_performance'],
      wickets: player['wickets'],
    );
    await dbHelper.insertPlayer(newPlayer);
  }
}

Future<void> loadLiveScores(DatabaseHelper dbHelper) async {
  for (int i = 1; i <= 3; i++) {
    final String response = await rootBundle.loadString('assets/data/live_score_match$i.json');
    final Map<String, dynamic> liveScoreData = json.decode(response);

    LiveScore liveScore = LiveScore(
      match: liveScoreData['match'],
      team1: liveScoreData['team1'],
      team2: liveScoreData['team2'],
      score: liveScoreData['score'],
      overs: liveScoreData['overs'],
      status: liveScoreData['status'],
    );

    await dbHelper.insertLiveScore(liveScore);
  }
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  MyApp({required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Signup',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: initialScreen,
    );
  }
}
