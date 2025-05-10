import 'package:flutter/material.dart';
import 'spf_form_widget.dart';
import 'spf_recommendation_table.dart';
import 'user_spf_recommendation.dart';

class SPFTrackerPage extends StatelessWidget {
  const SPFTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SPF Tracker")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SPFFormWidget(),
            SizedBox(height: 24),
            UserSPFRecommendation(),
            SizedBox(height: 24),
            Text("SPF Recommendation Table", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SPFRecommendationTable(),
          ],
        ),
      ),
    );
  }
}
