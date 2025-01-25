import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/player.dart';
import '../models/live_score.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Player> players = [];
  List<LiveScore> liveScores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch players and live scores from the database
    List<Player> playerList = await dbHelper.getPlayers();
    List<LiveScore> liveScoreList = await dbHelper.getLiveScores();

    setState(() {
      players = playerList;
      liveScores = liveScoreList;
      isLoading = false;
    });
  }

  // Dialog for editing a player
  void editPlayer(Player player) {
    TextEditingController nameController = TextEditingController(text: player.name);
    TextEditingController ageController = TextEditingController(text: player.age.toString());
    TextEditingController dailyScoreController = TextEditingController(text: player.dailyScore.toString());
    TextEditingController yearlyScoreController = TextEditingController(text: player.yearlyScore.toString());
    TextEditingController bestPerformanceController = TextEditingController(text: player.bestPerformance);
    TextEditingController wicketsController = TextEditingController(text: player.wickets.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Player"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: dailyScoreController,
                  decoration: InputDecoration(labelText: "Daily Score"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: yearlyScoreController,
                  decoration: InputDecoration(labelText: "Yearly Score"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: bestPerformanceController,
                  decoration: InputDecoration(labelText: "Best Performance"),
                ),
                TextField(
                  controller: wicketsController,
                  decoration: InputDecoration(labelText: "Wickets"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Update the player in the database
                Player updatedPlayer = Player(
                  name: nameController.text,
                  age: int.parse(ageController.text),
                  dailyScore: int.parse(dailyScoreController.text),
                  yearlyScore: int.parse(yearlyScoreController.text),
                  bestPerformance: bestPerformanceController.text,
                  wickets: int.parse(wicketsController.text),
                );

                await dbHelper.updatePlayer(updatedPlayer);

                Navigator.pop(context);
                fetchData(); // Refresh the UI
              },
              child: Text("Update"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Dialog for editing a live score
  void editLiveScore(LiveScore liveScore) {
    TextEditingController team1Controller = TextEditingController(text: liveScore.team1);
    TextEditingController team2Controller = TextEditingController(text: liveScore.team2);
    TextEditingController scoreController = TextEditingController(text: liveScore.score);
    TextEditingController oversController = TextEditingController(text: liveScore.overs);
    TextEditingController statusController = TextEditingController(text: liveScore.status);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Live Score"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Match: ${liveScore.match}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: team1Controller,
                  decoration: InputDecoration(labelText: "Team 1"),
                ),
                TextField(
                  controller: team2Controller,
                  decoration: InputDecoration(labelText: "Team 2"),
                ),
                TextField(
                  controller: scoreController,
                  decoration: InputDecoration(labelText: "Score"),
                ),
                TextField(
                  controller: oversController,
                  decoration: InputDecoration(labelText: "Overs"),
                ),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: "Status"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Update the live score in the database
                LiveScore updatedLiveScore = LiveScore(
                  match: liveScore.match, // Match is not editable
                  team1: team1Controller.text,
                  team2: team2Controller.text,
                  score: scoreController.text,
                  overs: oversController.text,
                  status: statusController.text,
                );

                await dbHelper.updateLiveScore(updatedLiveScore);

                Navigator.pop(context);
                fetchData(); // Refresh the UI
              },
              child: Text("Update"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void deletePlayer(String name) async {
    await dbHelper.deletePlayer(name);
    fetchData();
  }

  void deleteLiveScore(String match) async {
    await dbHelper.deleteLiveScore(match);
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Actions"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          Text(
            "Players",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...players.map((player) => ListTile(
            title: Text(player.name),
            subtitle: Text("Age: ${player.age} | Best: ${player.bestPerformance}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => editPlayer(player),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deletePlayer(player.name),
                ),
              ],
            ),
          )),
          Divider(),
          Text(
            "Live Scores",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...liveScores.map((liveScore) => ListTile(
            title: Text(liveScore.match),
            subtitle: Text("${liveScore.team1} vs ${liveScore.team2} | Score: ${liveScore.score}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => editLiveScore(liveScore),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteLiveScore(liveScore.match),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
