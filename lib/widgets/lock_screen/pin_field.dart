import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class PinField extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final Color ringColor;
  const PinField(this.index, this.selectedIndex, this.ringColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal:
            proportionateScreenWidthFraction(ScreenFraction.quantile) * 2,
      ),
      width: proportionateScreenWidth(50),
      height: proportionateScreenWidth(50),
      decoration: BoxDecoration(
        color: selectedIndex >= index
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.background,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(96),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: selectedIndex == index - 1
                ? ringColor
                : Colors.black.withAlpha(0),
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
