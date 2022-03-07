import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';

class PinField extends StatelessWidget {
  final int index;
  final int selectedIndex;
  PinField(this.index, this.selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal:
              proportionateScreenWidthFraction(ScreenFraction.QUANTILE) * 2),
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
              offset: Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 16,
            ),
            BoxShadow(
              color: selectedIndex == index - 1
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.black.withAlpha(0),
              spreadRadius: 2,
            ),
          ]),
    );
  }
}
