import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flareline/models/user_model.dart';
import 'package:flareline/pages/dashboard/widgets/spf_selector_widget.dart';
import 'package:flareline/services/firestore_service.dart';
import 'package:flareline/services/notification_service.dart';

import 'package:flutter/material.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline/core/theme/global_colors.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flareline/flutter_gen/app_localizations.dart';

import 'widgets/uv_index_widget.dart';
import 'widgets/exposure_timer_widget.dart';

class DashboardPage extends LayoutWidget {
  const DashboardPage({super.key});

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return const _DashboardContent();
  }
}


class _DashboardContent extends StatefulWidget {
  const _DashboardContent({super.key});

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  Timer? _timer;
  int _safeTimeLeft = 0;
  bool _isSpfActive = false;
  UserModel? _user;
  SPFTrackerModel? _latestSpf;
  double _uvIndex = 0;
  int _maxMinutes = 0;
  bool _notifiedSafeTimeExpired = false;
  bool _notifiedHighUV = false;
  bool _notifiedModerateUV = false;
  bool _notifiedExtendedExposure = false;
  int _exposureMinutes = 0;


  double getMED(String skinType) {
    switch (skinType.toLowerCase()) {
      case 'i':
        return 200;
      case 'ii':
        return 250;
      case 'iii':
        return 300;
      case 'iv':
        return 450;
      case 'v':
        return 600;
      case 'vi':
        return 800;
      default:
        return 250;
    }
  }

  int calculateEffectiveSPFTime(double med, double uv, double spf) {
      if (uv <= 0) return 0;
    return ((med * spf) / uv).round();
  }

  int calculateSafeTimeWithoutSPF(double med, double uv) {
      if (uv <= 0) return 0;
    return (med / uv).round();
  }

  Future<void> loadData() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final user = await FirestoreService().getUser(uid);
  final latestSpf = await FirestoreService().getLatestSPFTracking(uid);
  final now = DateTime.now();
  final isSpfActive = latestSpf != null && latestSpf.expiresAt.isAfter(now);
  final med = getMED(user!.skinType);
  final uv = user!.currentUVIndex;

  final effectiveSPFTime = isSpfActive
      ? calculateEffectiveSPFTime(med, uv, latestSpf!.spfValue)
      : 0;

  final safeTime = !isSpfActive
      ? calculateSafeTimeWithoutSPF(med, uv)
      : 0;

  final maxMinutes = isSpfActive ? effectiveSPFTime : safeTime;

  setState(() {
    _user = user;
    _latestSpf = latestSpf;
    _isSpfActive = isSpfActive;
    _uvIndex = uv;
    _maxMinutes = maxMinutes;
    _safeTimeLeft = maxMinutes;
    _notifiedSafeTimeExpired = false;
    _notifiedHighUV = false;
    _notifiedModerateUV = false;
    _notifiedExtendedExposure = false;
    _exposureMinutes = 0;

  });
}


  @override
  void initState() {
    super.initState();
    loadData();

    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
  setState(() {
    if (_safeTimeLeft > 0) {
      _safeTimeLeft--;
      _exposureMinutes++;
    } else if (!_notifiedSafeTimeExpired) {
      NotificationService.showNotification(
        title: 'Exposure Alert',
        body: 'Your safe exposure time has expired. Please take precautions.',
      );
      _notifiedSafeTimeExpired = true;
    }

    // UV Index-based Notifications
    if (_uvIndex > 9 && !_notifiedHighUV) {
      NotificationService.showNotification(
        title: 'High UV Index',
        body: 'UV index is extremely high. It is advised to stay indoors.',
      );
      _notifiedHighUV = true;
    } else if (_uvIndex >= 7 && _uvIndex <= 9 && !_notifiedModerateUV) {
      if (_isSpfActive) {
        NotificationService.showNotification(
          title: 'Moderate UV Index',
          body: 'UV index is high. Wear protective clothing.',
        );
      } else {
        NotificationService.showNotification(
          title: 'Moderate UV Index',
          body: 'Apply sunscreen and wear protective clothing.',
        );
      }
      _notifiedModerateUV = true;
    }

    // Prolonged Exposure Notification
    if (_exposureMinutes > 240 && !_notifiedExtendedExposure) {
      NotificationService.showNotification(
        title: 'Extended Exposure',
        body: 'You have been exposed to UV for over 4 hours. Consider taking a break.',
      );
      _notifiedExtendedExposure = true;
    }
  });
});

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Color alertColor;
    String statusText;
    String detailText;

    if (_isSpfActive) {
      alertColor = Colors.green;
      statusText = "✅ SPF protection active";
      final minutesLeft = _latestSpf!.expiresAt.difference(DateTime.now()).inMinutes;
      detailText = "Protection expires in ~$minutesLeft min";
    } else {
      alertColor = _safeTimeLeft <= 5 ? Colors.red : Colors.orange;
      statusText = "⚠️ SPF expired or not applied";
      detailText = "Safe exposure time left: ~$_safeTimeLeft min at UV ${_uvIndex.toStringAsFixed(1)}";
    }

    return CommonCard(
      height: 800,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UVIndexWidget(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: alertColor.withOpacity(0.1),
                  border: Border.all(color: alertColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(statusText,
                        style: TextStyle(
                            fontSize: 18,
                            color: alertColor,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(detailText,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, "/spfTracker");
                        await loadData(); // Refresh SPF status after returning
},  
                      child: Text(_isSpfActive ? "Update SPF" : "Apply SPF"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ExposureTimerWidget(maxMinutes: _maxMinutes),
            ],
          ),
        ),
      ),
    );
  }
}
