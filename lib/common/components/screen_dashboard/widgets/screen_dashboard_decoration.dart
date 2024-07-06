//  Screen Dashboard Decoration - Generic Decoration Styles attached to every ScreenDashboardElement, with some options to customize the experience
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_dashboard/enums/bgkey.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';

class ScreenDashboardDecoration extends StatelessWidget {
  const ScreenDashboardDecoration({
    super.key,
    required this.bgKey,
    required this.colors,
    required this.cardBorderRadius,
    required this.child,
    required this.paddingTB,
  }) : assert(
          paddingTB.length == 2,
          "Assigning more than 2 doubles in paddingTB does not make any sense, only the first two items will be evaluated.",
        );

  final BGKey bgKey;
  final ColorScheme colors;
  final double cardBorderRadius;
  final Widget child;
  final List<double> paddingTB;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding =
        context.proportionateScreenWidthFraction(ScreenFraction.quantile) * 4;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, paddingTB[0], horizontalPadding, paddingTB[1]),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: colors.onSurface.withAlpha(64),
              blurRadius: 12.0,
              spreadRadius: 1.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          child: Material(
            child: Container(
              decoration: BoxDecoration(
                color: bgKey == BGKey.solid ? Colors.white : null,
                image: bgKey == BGKey.hexagon
                    ? const DecorationImage(
                        image: AssetImage("assets/images/cubes.png"),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
