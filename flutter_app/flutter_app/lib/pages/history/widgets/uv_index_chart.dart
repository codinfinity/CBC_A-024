import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UVIndexChart extends StatelessWidget {
  final List<double> weeklyUV;

  const UVIndexChart({super.key, required this.weeklyUV});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
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
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: List.generate(7, (i) => FlSpot(i.toDouble(), weeklyUV[i])),
              barWidth: 3,
              color: Colors.deepOrange,
              dotData: FlDotData(show: true),
            )
          ],
        ),
      ),
    );
  }
}
