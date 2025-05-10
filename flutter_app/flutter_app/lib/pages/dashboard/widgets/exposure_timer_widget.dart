import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExposureTimerWidget extends StatelessWidget {
  const ExposureTimerWidget({super.key});

  int calculateExposureMinutes(List<dynamic> logs) {
  if (logs.isEmpty) return 0;

  final exposureData = logs.map((e) => {
        'start': DateTime.parse(e['exposureStart']),
        'end': DateTime.parse(e['exposureEnd']),
      }).toList();

  final total = exposureData.fold<Duration>(
      Duration.zero,
      (sum, log) =>
          sum +
          (log['end'] as DateTime)
              .difference(log['start'] as DateTime));

  return total.inMinutes;
}


  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Text("User not logged in");

   return StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const CircularProgressIndicator();

    final userData = snapshot.data!.data() as Map<String, dynamic>;
    final exposureLogs = userData['exposureLogs'] ?? [];

    int exposureMinutes = calculateExposureMinutes(exposureLogs);
    int maxMinutes = 60;  // Maximum safe exposure time (could change dynamically)
    double progress = (exposureMinutes / maxMinutes).clamp(0, 1);

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
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress < 0.7
                        ? Colors.green
                        : (progress < 0.9
                            ? Colors.orange
                            : Colors.red),
                  ),
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
