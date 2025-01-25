import 'package:cricketapp/screens/player_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../models/live_score.dart';
import '../models/player.dart';
import '../widgets/live_matches_carousel.dart';
import 'admin_screen.dart';
import 'login_screen.dart';


class PlayersScreen extends StatefulWidget {
  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<LiveScore> liveScores = [];
  List<Player> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    setState(() {
      isLoading = true; // Start loading
    });

    try {
      List<LiveScore> scores = await dbHelper.getLiveScores();
      List<Player> playerData = await dbHelper.getPlayers();

      setState(() {
        liveScores = scores;
        players = playerData;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // Clear the logged-in user state
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('loggedInUser');

                // Navigate back to LoginScreen
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
          title: Text("Cricket Stats"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Live Matches"),
              Tab(text: "Players"),
            ],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            LiveMatchesCarousel(liveScores: liveScores), // Carousel for live matches
            buildPlayersTab(players), // Players tab
          ],
        ),
        floatingActionButton: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final prefs = snapshot.data as SharedPreferences;
              final String? loggedInUser = prefs.getString('loggedInUser');
              if (loggedInUser == 'operator@op.com') {
                return FloatingActionButton(
                  child: Icon(Icons.edit),
                  onPressed: () async{
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminScreen()),
                    );

                    // Fetch the updated data when returning from AdminScreen
                    fetchData();
                  },
                );
              }
            }
            return SizedBox(); // No FAB for other users
          },
        ),
      ),
    );
  }

  Widget buildPlayersTab(List<Player> players) {
    if (players.isEmpty) {
      return Center(
        child: Text("No players found.", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return ListTile(
          title: Text(player.name),
          subtitle: Text("Best: ${player.bestPerformance}"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerDetailsScreen(player: player),
              ),
            );
          },
        );
      },
    );
  }
}
