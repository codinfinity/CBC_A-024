import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';

class TodayUVChart extends StatelessWidget {
  final List<ExposureLogModel> logs;

  const TodayUVChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final spots = logs
        .map((log) {
          final hour = log.timestamp.hour + log.timestamp.minute / 60;
          return FlSpot(hour, log.uvIndex);
        })
        .toList();

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, _) {
                  return Text("${value.toInt()}h");
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          minX: 7,
          maxX: 19,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: spots,
              barWidth: 3,
              color: Colors.purple,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
