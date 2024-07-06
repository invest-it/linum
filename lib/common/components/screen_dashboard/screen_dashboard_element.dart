import 'package:flutter/material.dart';

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
    BGKey bgKey = BGKey.solid,
    double cardBorderRadius = 16.0,
  }) {
    return ScreenDashboardElement._(
      element: SizedBox(
        height: height,
        child: buildDecoration(
          bgKey: bgKey,
          colors: colorScheme,
          cardBorderRadius: cardBorderRadius,
          child: content,
        ),
      ),
    );
  }

  factory ScreenDashboardElement.flexible({
    //* FLEXIBLE LAYOUT - Only takes as much space as its children need (flexible object).
    required Widget content,
    required ColorScheme colorScheme,
    BGKey bgKey = BGKey.solid,
    double cardBorderRadius = 16.0,
  }) {
    return ScreenDashboardElement._(
      element: Flexible(
        child: buildDecoration(
          bgKey: bgKey,
          colors: colorScheme,
          cardBorderRadius: cardBorderRadius,
          child: content,
        ),
      ),
    );
  }

  factory ScreenDashboardElement.expanding({
    //* EXPANDING LAYOUT - Takes as much space as there is available (constrained by the maximum height constraint imposed by the ScreenDashboardSkeleton).
    required Widget content,
    required ColorScheme colorScheme,
    BGKey bgKey = BGKey.solid,
    double cardBorderRadius = 16.0,
  }) {
    return ScreenDashboardElement._(
      element: Expanded(
        child: buildDecoration(
          bgKey: bgKey,
          colors: colorScheme,
          cardBorderRadius: cardBorderRadius,
          child: content,
        ),
      ),
    );
  }

  Widget buildDecoration({
    required BGKey bgKey,
    required ColorScheme colors,
    required double cardBorderRadius,
    required Widget child,
  }) {
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

  @override
  Widget build(BuildContext context) {
    return element;
  }
}

enum BGKey {
  solid, // Solid color (currently white)
  hexagon,
  //FUTURE Add more options if needed
}
