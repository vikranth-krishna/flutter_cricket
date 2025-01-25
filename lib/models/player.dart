// lib/models/player.dart
class Player {
  final String name;
  final int age;
  final int dailyScore;
  final int yearlyScore;
  final String bestPerformance;
  final int wickets;

  Player({
    required this.name,
    required this.age,
    required this.dailyScore,
    required this.yearlyScore,
    required this.bestPerformance,
    required this.wickets,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'dailyScore': dailyScore,
      'yearlyScore': yearlyScore,
      'bestPerformance': bestPerformance,
      'wickets': wickets,
    };
  }
}