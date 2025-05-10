import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flareline/models/user_model.dart';
import 'package:flareline/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline/core/theme/global_colors.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flareline/flutter_gen/app_localizations.dart';

import 'widgets/uv_index_widget.dart';
import 'widgets/exposure_timer_widget.dart';


class DashboardPage extends LayoutWidget {
  const DashboardPage({super.key});

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
    return ((med * spf) / uv).round();
  }

  int calculateSafeTimeWithoutSPF(double med, double uv) {
    return (med / uv).round();
  }

  Future<Duration> getTodayExposureDuration(String uid) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final logsSnap = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('exposureLogs')
      .where('logDate', isEqualTo: today.toIso8601String())
      .get();

  Duration total = Duration.zero;

  for (var doc in logsSnap.docs) {
    final log = ExposureLogModel.fromJson(doc.data());
    total += log.duration;
  }

  return total;
}


  @override
  String breakTabTitle(BuildContext context) {
    return AppLocalizations.of(context)!.dashboard;
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("User not logged in"));
    }

    return CommonCard(
      height: 800,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: Future.wait([
  FirestoreService().getUser(uid),
  FirestoreService().getSPFTracking(uid),
  getTodayExposureDuration(uid),
]),

          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();

            final user = snapshot.data![0] as UserModel;
            final List<SPFTrackerModel> spfList = snapshot.data![1];
            final latestSpf = spfList.isNotEmpty
                ? spfList.reduce((a, b) => a.appliedAt.isAfter(b.appliedAt) ? a : b)
                : null;
            final Duration todayExposure = snapshot.data![2] as Duration;
            final now = DateTime.now();
            final isSpfActive = latestSpf != null && latestSpf.expiresAt.isAfter(now);

            final uvIndex = user.currentUVIndex;
            final med = getMED(user.skinType);
            final effectiveSPFTime = isSpfActive
                ? calculateEffectiveSPFTime(med, uvIndex, latestSpf!.spfValue)
                : 0;

            final safeTime = !isSpfActive
                ? calculateSafeTimeWithoutSPF(med, uvIndex)
                : 0;

            Color alertColor;
            String statusText;
            String detailText;

            if (isSpfActive) {
              alertColor = Colors.green;
              statusText = "✅ SPF protection active";
              final minutesLeft =
                  latestSpf.expiresAt.difference(now).inMinutes;
              detailText = "Protection expires in ~$minutesLeft min";
            } else {
              if (safeTime <= 5) {
                alertColor = Colors.red;
              } else {
                alertColor = Colors.orange;
              }
              statusText = "⚠️ SPF expired or not applied";
              detailText =
                  "Safe exposure time left: ~$safeTime min at UV ${uvIndex.toStringAsFixed(1)}";
            }

            return SingleChildScrollView(
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
                          onPressed: () {
                            Navigator.pushNamed(context, "/spfTimer");
                          },
                          child:
                              Text(isSpfActive ? "Update SPF" : "Apply SPF"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const ExposureTimerWidget(),

                  const SizedBox(height: 20),
                  //const SPFSelectorWidget(),

                  const SizedBox(height: 20),
                  //const RecommendationWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
