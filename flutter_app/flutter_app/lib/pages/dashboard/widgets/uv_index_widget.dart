import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UVIndexWidget extends StatelessWidget {
  const UVIndexWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return const Text("User not logged in");

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final uvIndex = (data['currentUVIndex'] ?? 0).toDouble();

        Color color;
        if (uvIndex < 3) {
          color = Colors.green;
        } else if (uvIndex < 6) {
          color = Colors.yellow;
        }
        else {color = Colors.red;
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.wb_sunny, size: 28),
              
              const SizedBox(width: 10),
              Text("UV Index: $uvIndex", style: const TextStyle(fontSize: 18)),
            ],
          ),
        );
      },
    );
  }
}
