//  HomeScreenDashboard - Main Widget for the ScreenDashboard, containing specific instructions on how it looks on the Home Screen.
//
//  Author: NightmindOfficial
//  Co-Author: n/a

import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_dashboard/screen_dashboard_element.dart';
import 'package:linum/common/components/screen_dashboard/screen_dashboard_skeleton.dart';

class HomeScreenDashboard extends StatelessWidget {
  const HomeScreenDashboard({super.key});

  @override
  ScreenDashboardSkeleton build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ScreenDashboardSkeleton(
      screenDashboardElements: [
        ScreenDashboardElement.expanding(
          content: const Placeholder(),
          bgKey: BGKey.hexagon,
          colorScheme: colors,
        ),
        ScreenDashboardElement.fixed(
          content: const Placeholder(),
          height: 64,
          colorScheme: colors,
        ),
      ],
    );
  }
}
