import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_dashboard/enums/bgkey.dart';

class ScreenDashboardDecoration extends StatelessWidget {
  const ScreenDashboardDecoration({
    super.key,
    required this.bgKey,
    required this.colors,
    required this.cardBorderRadius,
    required this.child,
  });

  final BGKey bgKey;
  final ColorScheme colors;
  final double cardBorderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
    );
  }
}
