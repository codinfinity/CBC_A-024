import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SPFFormWidget extends StatefulWidget {
  const SPFFormWidget({super.key});

  @override
  State<SPFFormWidget> createState() => _SPFFormWidgetState();
}

class _SPFFormWidgetState extends State<SPFFormWidget> {
  int? selectedSPF;
  DateTime? selectedTime;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submit() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || selectedSPF == null || selectedTime == null) return;

    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final userData = userDoc.data();
      if (userData == null) return;

      final skinTypeRaw = userData['skinType'];
      final skinType = int.tryParse(skinTypeRaw.toString()) ?? 3;  // default to 3 if parsing fails
      final uvIndex = userData['currentUVIndex'] ?? 5.0; // fallback UV

      final protectionDuration = calculateProtectionDuration(
        spf: selectedSPF!,
        uvIndex: uvIndex.toDouble(),
        skinType: skinType ?? 3,
      );

      final expiresAt = selectedTime!.add(protectionDuration);

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('spf_tracker')
          .doc('latest')
          .set({
        'spfLevel': selectedSPF,
        'appliedAt': selectedTime,
        'expiresAt': expiresAt,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("SPF data saved. Protection until ${expiresAt.toLocal()}")),
      );
    } catch (e) {
      print("Error in SPF submit: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save SPF data")),
      );
    }
  }

  Duration calculateProtectionDuration({
    required int spf,
    required double uvIndex,
    required int skinType,
  }) {
    
    final baseBurnTime = {
      1: 10,  // Type I – very fair
      2: 15,  // Type II – fair
      3: 20,  // Type III – medium
      4: 30,  // Type IV – olive
      5: 40,  // Type V – brown
      6: 60,  // Type VI – dark brown/black
    };

    final timeToBurn = baseBurnTime[skinType] ?? 15;

    // Prevent division by zero or near-zero UV
    if (uvIndex < 0.1) {
      return const Duration(minutes: 999); // Arbitrarily long protection time
    }

    final effectiveMinutes = timeToBurn * spf / uvIndex;
    return Duration(minutes: effectiveMinutes.round());
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select SPF Level:", style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [15, 30, 50, 100].map((spf) {
            return ChoiceChip(
              label: Text("SPF $spf"),
              selected: selectedSPF == spf,
              onSelected: (_) => setState(() => selectedSPF = spf),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text("Select Time of Application: ${selectedTime != null ? selectedTime.toString() : ''}"),
        ElevatedButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              final now = DateTime.now();
              setState(() {
                selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
              });
            }
          },
          child: const Text("Pick Time"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _submit, child: const Text("Submit SPF Data")),
      ],
    );
  }
}
