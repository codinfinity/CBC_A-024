import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSPFRecommendation extends StatelessWidget {
  const UserSPFRecommendation({super.key});

  String getRecommendation(int uvi, String skinType) {
    if (uvi <= 2) {
      return skinType == "I" || skinType == "II" || skinType == "III" ? "SPF 15" : "Optional or SPF 15";
    } else if (uvi <= 5) {
      return skinType == "I" || skinType == "II" || skinType == "III" ? "SPF 30" : "SPF 15–30";
    } else if (uvi <= 7) {
      return skinType == "I" || skinType == "II" || skinType == "III" ? "SPF 50" : "SPF 30–50";
    } else {
      return "SPF 50+ + protective clothing";
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Text("User not found");

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final skinType = data['skinType'] ?? 'III';
        final currentUVI = (data['currentUVIndex'] ?? 5).toInt();

        final reco = getRecommendation(currentUVI, skinType);

        return Text("Recommended SPF for you: $reco",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      },
    );
  }
}
