import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/live_score.dart';
import '../models/user.dart';
import '../models/player.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user.db');
    return await openDatabase(
      path,
      version: 2, // Incremented version to trigger onCreate
      onCreate: (db, version) {
        return Future.wait([
          db.execute(
            'CREATE TABLE users(email TEXT PRIMARY KEY, password TEXT)',
          ),
          db.execute(
            'CREATE TABLE players(name TEXT PRIMARY KEY, age INTEGER, dailyScore INTEGER, yearlyScore INTEGER, bestPerformance TEXT, wickets INTEGER)',
          ),
          db.execute(
            'CREATE TABLE live_scores(match TEXT PRIMARY KEY, team1 TEXT, team2 TEXT, score TEXT, overs TEXT, status TEXT)',
          ),
        ]);
      },
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User(
        email: maps.first['email'],
        password: maps.first['password'],
      );
    }
    return null;
  }

  Future<void> insertPlayer(Player player) async {
    final db = await database;
    await db.insert(
      'players',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Player>> getPlayers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('players');
    return List.generate(maps.length, (i) {
      return Player(
        name: maps[i]['name'],
        age: maps[i]['age'],
        dailyScore: maps[i]['dailyScore'],
        yearlyScore: maps[i]['yearlyScore'],
        bestPerformance: maps[i]['bestPerformance'],
        wickets: maps[i]['wickets'],
      );
    });
  }

  Future<void> insertLiveScore(LiveScore liveScore) async {
    final db = await database;
    await db.insert(
      'live_scores',
      liveScore.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LiveScore>> getLiveScores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('live_scores');
    return List.generate(maps.length, (i) {
      return LiveScore(
        match: maps[i]['match'],
        team1: maps[i]['team1'],
        team2: maps[i]['team2'],
        score: maps[i]['score'],
        overs: maps[i]['overs'],
        status: maps[i]['status'],
      );
    });
  }

  // New Method: Delete Player
  Future<void> deletePlayer(String name) async {
    final db = await database;
    await db.delete(
      'players',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  // New Method: Delete Live Score
  Future<void> deleteLiveScore(String match) async {
    final db = await database;
    await db.delete(
      'live_scores',
      where: 'match = ?',
      whereArgs: [match],
    );
  }

  // New Method: Update Player
  Future<void> updatePlayer(Player player) async {
    final db = await database;
    await db.update(
      'players',
      player.toMap(),
      where: 'name = ?',
      whereArgs: [player.name],
    );
  }

  // New Method: Update Live Score
  Future<void> updateLiveScore(LiveScore liveScore) async {
    final db = await database;
    await db.update(
      'live_scores',
      liveScore.toMap(),
      where: 'match = ?', // Ensures the correct match is updated
      whereArgs: [liveScore.match],
    );
  }

}
