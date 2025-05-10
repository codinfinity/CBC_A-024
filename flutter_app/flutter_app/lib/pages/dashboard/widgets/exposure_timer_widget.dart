import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExposureTimerWidget extends StatelessWidget {
  const ExposureTimerWidget({super.key});

  // Dummy method to calculate exposure duration based on UV index change timestamps
  int calculateExposureMinutes(List<dynamic> uvTimestamps) {
    if (uvTimestamps.isEmpty) return 0;

    uvTimestamps.sort(); // Ensure chronological order
    DateTime start = (uvTimestamps.first as Timestamp).toDate();
    DateTime end = (uvTimestamps.last as Timestamp).toDate();
    return end.difference(start).inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc('test-user') // Replace with dynamic user ID
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final List<dynamic> uvTimestamps = userData['uv_exposure_log'] ?? [];

        int exposureMinutes = calculateExposureMinutes(uvTimestamps);
        int maxMinutes = 60;
        double progress = (exposureMinutes / maxMinutes).clamp(0, 1);

        return Stack(
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
                  progress < 0.7 ? Colors.green : (progress < 0.9 ? Colors.orange : Colors.red),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$exposureMinutes min",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "UV Exposure",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
