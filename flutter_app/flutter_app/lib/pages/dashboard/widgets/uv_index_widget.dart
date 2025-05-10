import 'package:flutter/material.dart';

class UVIndexWidget extends StatelessWidget {
  const UVIndexWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double uvIndex = 6.2; // Replace with real-time from Firebase later

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("UV Index Now", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text(
            uvIndex.toStringAsFixed(1),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.deepOrange),
          ),
        ],
      ),
    );
  }
}
