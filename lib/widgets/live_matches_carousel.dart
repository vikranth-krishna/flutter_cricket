import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/live_score.dart';
import '../models/chart_data.dart';

class LiveMatchesCarousel extends StatefulWidget {
  final List<LiveScore> liveScores;

  const LiveMatchesCarousel({Key? key, required this.liveScores}) : super(key: key);

  @override
  _LiveMatchesCarouselState createState() => _LiveMatchesCarouselState();
}

class _LiveMatchesCarouselState extends State<LiveMatchesCarousel> {
  late Timer _timer;
  int _currentAssetIndex = 0;

  final List<String> assetPaths = [
    'assets/images/out.json',
    'assets/images/4.json',
    'assets/images/bowl.json',
    'assets/images/6.json',
  ]; // Add more assets here

  @override
  void initState() {
    super.initState();
    _startAssetSwitcher();
  }

  void _startAssetSwitcher() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentAssetIndex = (_currentAssetIndex + 1) % assetPaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.liveScores.isEmpty) {
      return Center(
        child: Text(
          "No live matches available.",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 400.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        autoPlayInterval: Duration(seconds: 3),
      ),
      items: widget.liveScores.map((score) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Match Header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: score.status == "In Progress" ? Colors.red : Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                score.status,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Lottie.asset('assets/images/screen.json', height: 20),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                score.match,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Lottie.asset(assetPaths[_currentAssetIndex], height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Match Details
                    Text(
                      "${score.team1} vs ${score.team2}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("${score.team1}: ${score.score}", style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Text("${score.overs} Overs", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Line Chart for Match
                    Expanded(
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title: ChartTitle(text: 'Score Trend'),
                        legend: Legend(isVisible: false),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          LineSeries<ChartData, String>(
                            dataSource: getChartData(),
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // Generate random/hardcoded chart data
  List<ChartData> getChartData() {
    return [
      ChartData('Over 1', 30),
      ChartData('Over 2', 40),
      ChartData('Over 3', 60),
      ChartData('Over 4', 80),
      ChartData('Over 5', 100),
      ChartData('Over 6', 120),
    ];
  }
}
