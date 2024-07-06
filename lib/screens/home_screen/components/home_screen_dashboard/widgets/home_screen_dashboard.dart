//  HomeScreenDashboard - Main Widget for the ScreenDashboard, containing specific instructions on how it looks on the Home Screen.
//
//  Author: NightmindOfficial
//  Co-Author: n/a

import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_dashboard/enums/bgkey.dart';
import 'package:linum/common/components/screen_dashboard/widgets/screen_dashboard_element.dart';
import 'package:linum/common/components/screen_dashboard/widgets/screen_dashboard_skeleton.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';

class HomeScreenDashboard extends StatelessWidget {
  const HomeScreenDashboard({super.key});

  @override
  ScreenDashboardSkeleton build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hP =
        context.proportionateScreenWidthFraction(ScreenFraction.quantile) * 5;

    return ScreenDashboardSkeleton(
      screenDashboardElements: [
        ScreenDashboardElement.flexible(
          content: const Text(
            "TIME WIDGET (CLD)",
          ),
          colorScheme: colors,
        ),
        ScreenDashboardElement.expanding(
          bgKey: BGKey.hexagon,
          content: const Text(
            "PRIMARY (EXP)",
          ),
          colorScheme: colors,
        ),
        ScreenDashboardElement.flexible(
          content: const Text("Context (CLD)"),
          paddingLTRB: [hP, 0, hP, 0],
          colorScheme: colors,
        ),
      ],
    );
  }
}
