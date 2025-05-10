import 'package:firebase_auth/firebase_auth.dart';
import 'package:flareline/models/user_model.dart';
import 'package:flareline/pages/history/widgets/today_uv_chart.dart';
import 'package:flareline/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
// ignore: unused_import
import 'package:flareline/core/theme/global_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/exposure_chart.dart';


class HistoryPage extends LayoutWidget {
  const HistoryPage({super.key});

  @override
  String breakTabTitle(BuildContext context) => "History";

  Future<Map<String, dynamic>> fetchChartData() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return {};

  final weeklyExposure = await FirestoreService().getWeeklyExposureDurations(uid);
  final todayUVLogs = await FirestoreService().getTodayUVFrom7to7(uid);

  return {
    'exposure': weeklyExposure,
    'uvToday': todayUVLogs,
  };
}


  @override
Widget contentDesktopWidget(BuildContext context) {
  return FutureBuilder<Map<String, dynamic>>(
    future: fetchChartData(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final exposureData = snapshot.data!['exposure'] as List<double>;
      final uvLogsToday = snapshot.data!['uvToday'] as List<ExposureLogModel>;

      return CommonCard(
        height: 800,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Weekly Exposure Time (min)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ExposureChart(weeklyExposure: exposureData),
                const SizedBox(height: 30),
                const Text("Today's UV Index (7am–7pm)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TodayUVChart(logs: uvLogsToday),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}