import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UV Radiation Guide'),
        backgroundColor: Colors.orange.shade300,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            title: '☀ What is Ultraviolet Radiation?',
            color: Colors.orange.shade100,
            content: '''
Energy from the sun reaches the earth as visible, infrared, and ultraviolet (UV) rays.

• UVA: 320 to 400 nm – causes aging, wrinkling, and skin elasticity loss.

• UVB: 280 to 320 nm – higher risk of skin cancer.

• UVC: 100 to 280 nm – absorbed by the atmosphere.

UVA increases UVB's damaging effects like cancer and cataracts.

Melanin in your skin tries to absorb UV rays. A suntan is the body’s defense, but sunburn shows melanin was overwhelmed. 
Too much exposure is dangerous and preventive measures are key to avoiding harm.
            ''',
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: '🧬 Skin Cancer',
            color: Colors.red.shade100,
            content: '''
More people are diagnosed with skin cancer each year in the U.S. than all other cancers combined.

• 1 in 5 Americans will get skin cancer in their lifetime.

• One American dies every hour from skin cancer.

The most preventable risk factor? UV exposure. Use sunscreen, stay in shade, and avoid tanning beds.
            ''',
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: '🧓 Premature Aging and Other Skin Damage',
            color: Colors.blue.shade100,
            content: '''
Chronic sun exposure causes premature aging:

• Actinic keratoses: rough, reddish spots—can lead to squamous cell carcinoma.

• Premature aging: thick, leathery, wrinkled skin—can be avoided with sun protection.

Up to 90% of visible aging is caused by sun damage, not time.
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            content.trim(),
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}