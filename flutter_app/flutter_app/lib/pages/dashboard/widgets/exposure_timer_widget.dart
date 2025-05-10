import 'package:firebase_auth/firebase_auth.dart';
import 'package:flareline/models/user_model.dart';
import 'package:flareline/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExposureTimerWidget extends StatelessWidget {
  final int maxMinutes;
  const ExposureTimerWidget({super.key, required this.maxMinutes});

  int calculateExposureMinutes(List<ExposureLogModel> logs) {
    if (logs.length < 2) return 0;
    Duration total = Duration.zero;

    for (int i = 0; i < logs.length - 1; i++) {
      final current = logs[i];
      final next = logs[i + 1];
      if (current.uvIndex > 3) {
        total += next.timestamp.difference(current.timestamp);
      }
    }

    return total.inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Text("User not logged in");

    return FutureBuilder<List<ExposureLogModel>>(
      future: FirestoreService().getTodayUVLogs(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final logs = snapshot.data!;
        int exposureMinutes = calculateExposureMinutes(logs);
        double progress = (exposureMinutes / maxMinutes).clamp(0, 1);

        Color ringColor = progress < 0.7
            ? Colors.green
            : (progress < 0.9 ? Colors.orange : Colors.red);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Exposure Time",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$exposureMinutes min",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text("UV Exposure",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

