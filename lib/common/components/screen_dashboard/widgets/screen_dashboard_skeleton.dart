//  Screen Dashboard Skeleton - General Layout Class of how Dashboards on Screens will be created and look like, and behave.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_dashboard/widgets/screen_dashboard_element.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';

class ScreenDashboardSkeleton extends StatelessWidget {
  final List<ScreenDashboardElement> screenDashboardElements;
  final ScreenFraction maxHeight;

  const ScreenDashboardSkeleton({
    super.key,
    required this.screenDashboardElements,
    this.maxHeight = ScreenFraction.onethird,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.proportionateScreenHeightFraction(maxHeight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: screenDashboardElements,
      ),
    );
  }
}
