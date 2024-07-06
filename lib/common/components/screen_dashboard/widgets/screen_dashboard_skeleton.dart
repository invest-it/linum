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
  final double heightConstraint;

  const ScreenDashboardSkeleton({
    super.key,
    required this.screenDashboardElements,
    this.heightConstraint = 0.33,
  }) : assert(
          heightConstraint > 0 && heightConstraint <= 1,
          'Height Constraint needs to be a decimal percentage (of the screen height) between 0 and 1',
        );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.proportionateScreenHeightFraction(
          ScreenFraction.onefifth,
        ), //TODO make this an argument
      ),
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: screenDashboardElements,
        ),
      ),
    );
  }
}
