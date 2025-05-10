import 'package:flutter/material.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline/core/theme/global_colors.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flareline/flutter_gen/app_localizations.dart';

import 'widgets/uv_index_widget.dart';
import 'widgets/exposure_timer_widget.dart';
import 'widgets/spf_selector_widget.dart';
import 'widgets/recommendation_widget.dart';

class DashboardPage extends LayoutWidget {
  const DashboardPage({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return AppLocalizations.of(context)!.dashboard; // or "Dashboard" directly
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return CommonCard(
      height: 800,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Current UV Index", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              UVIndexWidget(),
              SizedBox(height: 20),
              Text("Exposure Time", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ExposureTimerWidget(),
              SizedBox(height: 20),
              Text("SPF Tracker", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SPFSelectorWidget(),
              SizedBox(height: 20),
              RecommendationWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
