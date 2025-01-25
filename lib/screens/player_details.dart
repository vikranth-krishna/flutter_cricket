import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Syncfusion Chart package
import '../models/player.dart';

class PlayerDetailsScreen extends StatelessWidget {
  final Player player;

  const PlayerDetailsScreen({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player Details
            Text(
              player.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Age: ${player.age}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Best Performance: ${player.bestPerformance}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Daily Score: ${player.dailyScore}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Yearly Score: ${player.yearlyScore}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Wickets: ${player.wickets}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            // Pie Chart with Various Radius
            Expanded(
              child: SfCircularChart(
                title: ChartTitle(text: 'Player Statistics'),
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                ),
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: getChartData(), // Random Chart Data
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.value,
                    pointRadiusMapper: (ChartData data, _) => data.radius,
                    dataLabelMapper: (ChartData data, _) => '${data.category}: ${data.value}',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generate hardcoded chart data with descending values
  List<ChartData> getChartData() {
    return [
       // Largest slice
      ChartData('Daily Score', player.dailyScore.toDouble(), '90%'),
      ChartData('Wickets', player.wickets.toDouble(), '80%'),
      ChartData('Matches Played', 50.0, '70%'),
      ChartData('Centuries', 30.0, '60%'),
      ChartData('Half-Centuries', 20.0, '50%'),
      ChartData('Fours Hit', 10.0, '40%'), // Smallest slice
    ];
  }
}

// Data model for the pie chart
class ChartData {
  final String category;
  final double value;
  final String radius;

  ChartData(this.category, this.value, this.radius);
}
