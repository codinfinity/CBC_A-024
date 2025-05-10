import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExposureChart extends StatelessWidget {
  final List<double> weeklyExposure;

  const ExposureChart({super.key, required this.weeklyExposure});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Text(days[value.toInt()]);
                },
              ),
            ),
          ),
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: weeklyExposure[i],
                  color: Colors.blueAccent,
                  width: 20,
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
