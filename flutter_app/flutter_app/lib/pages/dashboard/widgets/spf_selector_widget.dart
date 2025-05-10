import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SPFSelectorWidget extends StatefulWidget {
  const SPFSelectorWidget({super.key});

  @override
  State<SPFSelectorWidget> createState() => _SPFSelectorWidgetState();
}

class _SPFSelectorWidgetState extends State<SPFSelectorWidget> {
  int? currentSpf;
  DateTime? appliedAt;
  DateTime? expiresAt;
  bool isLoading = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchLatestSpfEntry();
  }

  Future<void> _fetchLatestSpfEntry() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      // Option 1: Use "latest" document manually updated
      // final doc = await _firestore.collection('users').doc(uid).collection('spfTracker').doc('latest').get();

      // Option 2: Get latest entry by date (better for history + analytics)
      final query = await _firestore
          .collection('users')
          .doc(uid)
          .collection('spfTracker')
          .orderBy('appliedAt', descending: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        setState(() {
          currentSpf = data['spfLevel'];
          appliedAt = (data['appliedAt'] as Timestamp).toDate();
          expiresAt = (data['expiresAt'] as Timestamp).toDate();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching SPF tracker entry: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    Widget statusMessage;
    if (isLoading) {
      statusMessage = const CircularProgressIndicator();
    } else if (expiresAt != null && expiresAt!.isAfter(now)) {
      final timeLeft = expiresAt!.difference(now);
      statusMessage = Text(
        "SPF $currentSpf active.\nProtection time left: ${_formatDuration(timeLeft)}",
        style: const TextStyle(color: Colors.green),
      );
    } else {
      statusMessage = const Text(
        "No active SPF protection.\nYou may be exposed!",
        style: TextStyle(color: Colors.red),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        statusMessage,
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/spfTracker');
          },
          child: const Text("Update SPF Application"),
        )
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return "$hours hr ${minutes.toString().padLeft(2, '0')} min";
    } else {
      return "$minutes min";
    }
  }
}
