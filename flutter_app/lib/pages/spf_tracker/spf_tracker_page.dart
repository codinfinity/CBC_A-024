import 'package:flutter/material.dart';
import 'spf_form_widget.dart';
import 'spf_recommendation_table.dart';
import 'user_spf_recommendation.dart';

class SPFTrackerPage extends StatelessWidget {
  const SPFTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Soft yellow background
      appBar: AppBar(
        title: const Text("SPF Tracker"),
        backgroundColor: Colors.orange.shade300,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.orange.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: SPFFormWidget(),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.yellow.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: UserSPFRecommendation(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "SPF Recommendation Table",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 8),
            const SPFRecommendationTable(),
          ],
        ),
      ),
    );
  }
}