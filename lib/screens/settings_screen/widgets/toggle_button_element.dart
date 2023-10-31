//  Toggle Button Element - used in grouped button rows (e.g. for the Language Switcher on the Settings Screen).
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  Refactored: none

import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';

class ToggleButtonElement extends StatelessWidget {
  final String label;
  final double? fixedWidth;
  final double? horizontalPadding;
  final double? verticalPadding;
  late final double _horizontalNotProportionatePadding;
  late final double _verticalNotProportionatePadding;

  ToggleButtonElement(
    this.label, {
    this.fixedWidth,
    this.horizontalPadding,
    this.verticalPadding,
  }) {
    if (horizontalPadding == null) {
      _horizontalNotProportionatePadding = 20.0;
    }
    if (verticalPadding == null) {
      _verticalNotProportionatePadding = 16.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fixedWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context
              .proportionateScreenWidth(_horizontalNotProportionatePadding),
          vertical: context
              .proportionateScreenHeight(_verticalNotProportionatePadding),
        ),
        child: Center(
          child: Text(
            label,
          ),
        ),
      ),
    );
  }
}
