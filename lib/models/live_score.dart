// lib/models/live_score.dart
class LiveScore {
  final String match;
  final String team1;
  final String team2;
  final String score;
  final String overs;
  final String status;

  LiveScore({
    required this.match,
    required this.team1,
    required this.team2,
    required this.score,
    required this.overs,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'match': match,
      'team1': team1,
      'team2': team2,
      'score': score,
      'overs': overs,
      'status': status,
    };
  }
}