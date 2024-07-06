//  HomeScreenDashboard - Main Widget for the ScreenDashboard, containing specific instructions on how it looks on the Home Screen.
//
//  Author: NightmindOfficial
//  Co-Author: n/a

import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_dashboard/enums/bgkey.dart';
import 'package:linum/common/components/screen_dashboard/widgets/screen_dashboard_element.dart';
import 'package:linum/common/components/screen_dashboard/widgets/screen_dashboard_skeleton.dart';

class HomeScreenDashboard extends StatelessWidget {
  const HomeScreenDashboard({super.key});

  @override
  ScreenDashboardSkeleton build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ScreenDashboardSkeleton(
      screenDashboardElements: [
        ScreenDashboardElement.expanding(
          content: const Text(
              "Expanded - takes as much space as available, even if not needed"),
          bgKey: BGKey.hexagon,
          colorScheme: colors,
        ),
        ScreenDashboardElement.fixed(
          content: const Text(
              "Fixed Height - takes as much space as needed, limited"),
          height: 64,
          colorScheme: colors,
        ),
        ScreenDashboardElement.flexible(
          content: const Text(
              "Flexible - takes as much space as needed, without limits"),
          colorScheme: colors,
        ),
      ],
    );
  }
}
