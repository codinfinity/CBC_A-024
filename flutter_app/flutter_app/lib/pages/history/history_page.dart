import 'package:flutter/material.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
// ignore: unused_import
import 'package:flareline/core/theme/global_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/exposure_chart.dart';
import 'widgets/uv_index_chart.dart';

class HistoryPage extends LayoutWidget {
  const HistoryPage({super.key});

  @override
  String breakTabTitle(BuildContext context) => "History";

  Future<Map<String, List<double>>> fetchWeeklyData() async {
    final snapshot = await FirebaseFirestore.instance.collection('weeklyData').doc('user1').get();

    final data = snapshot.data();
    final exposure = List<double>.from(data?['exposure'] ?? [0, 0, 0, 0, 0, 0, 0]);
    final uv = List<double>.from(data?['uvIndex'] ?? [0, 0, 0, 0, 0, 0, 0]);

    return {'exposure': exposure, 'uv': uv};
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return FutureBuilder<Map<String, List<double>>>(
      future: fetchWeeklyData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final exposureData = data['exposure']!;
        final uvData = data['uv']!;

        return CommonCard(
          height: 800,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Weekly Exposure Time", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ExposureChart(weeklyExposure: exposureData),
                  const SizedBox(height: 30),
                  const Text("Weekly UV Index", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  UVIndexChart(weeklyUV: uvData),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
