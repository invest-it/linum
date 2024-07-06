//  Screen Dashboard Element - Primary Platform for an Item within a Screen Dashboard
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_dashboard/enums/bgkey.dart';
import 'package:linum/common/components/screen_dashboard/widgets/screen_dashboard_decoration.dart';

class ScreenDashboardElement extends StatelessWidget {
  final Widget element;

  const ScreenDashboardElement._({
    required this.element,
  });

  factory ScreenDashboardElement.fixed({
    //* FIXED LAYOUT - Pre-Determined Height and Width. !!! Be careful with this, it could break the layout if there is not enough space. !!! //FUTURE maybe we should make the fixed setting relative so that cannot happen.
    required Widget content,
    required double height,
    required ColorScheme colorScheme,
    List<double> paddingLTRB = const [8, 0, 8, 8],
    BGKey bgKey = BGKey.solid,
    double cardBorderRadius = 16.0,
  }) {
    return ScreenDashboardElement._(
      element: SizedBox(
        height: height,
        child: ScreenDashboardDecoration(
          bgKey: bgKey,
          colors: colorScheme,
          cardBorderRadius: cardBorderRadius,
          paddingLTRB: paddingLTRB,
          child: content,
        ),
      ),
    );
  }

  factory ScreenDashboardElement.flexible({
    //* FLEXIBLE LAYOUT - Only takes as much space as its children need (regular box).
    required Widget content,
    required ColorScheme colorScheme,
    List<double> paddingLTRB = const [8, 0, 8, 8],
    BGKey bgKey = BGKey.solid,
    double cardBorderRadius = 16.0,
  }) {
    return ScreenDashboardElement._(
      element: ScreenDashboardDecoration(
        bgKey: bgKey,
        colors: colorScheme,
        cardBorderRadius: cardBorderRadius,
        paddingLTRB: paddingLTRB,
        child: content,
      ),
    );
  }

  factory ScreenDashboardElement.expanding({
    //* EXPANDING LAYOUT - Takes as much space as there is available (constrained by the maximum height constraint imposed by the ScreenDashboardSkeleton).
    required Widget content,
    required ColorScheme colorScheme,
    List<double> paddingLTRB = const [8, 0, 8, 8],
    BGKey bgKey = BGKey.solid,
    double cardBorderRadius = 16.0,
  }) {
    return ScreenDashboardElement._(
      element: Expanded(
        child: ScreenDashboardDecoration(
          bgKey: bgKey,
          colors: colorScheme,
          cardBorderRadius: cardBorderRadius,
          paddingLTRB: paddingLTRB,
          child: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return element;
  }
}
