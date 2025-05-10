import 'package:flutter/material.dart';

class RecommendationWidget extends StatelessWidget {
  const RecommendationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with logic from UV + skin type
    String recommendation = "High UV! Seek shade & reapply SPF every 2 hours.";

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(child: Text(recommendation)),
        ],
      ),
    );
  }
}
