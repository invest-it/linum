//  Screen Dashboard Decoration - Generic Decoration Styles attached to every ScreenDashboardElement, with some options to customize the experience
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_dashboard/enums/bgkey.dart';

class ScreenDashboardDecoration extends StatelessWidget {
  const ScreenDashboardDecoration({
    super.key,
    required this.bgKey,
    required this.colors,
    required this.cardBorderRadius,
    required this.child,
    required this.paddingTB,
    required this.paddingLR,
  }) : assert(
          paddingTB.length == 2,
          "Assigning more than 2 doubles in paddingLTRB does not make any sense, only the first two items will be evaluated.",
        );

  final BGKey bgKey;
  final ColorScheme colors;
  final double cardBorderRadius;
  final Widget child;
  final List<double> paddingTB;
  final double paddingLR;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTB[0],
        bottom: paddingTB[1],
        left: paddingLR,
        right: paddingLR,
      ),
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
