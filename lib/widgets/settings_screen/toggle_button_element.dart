import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/country_flag_generator.dart';
import 'package:linum/frontend_functions/size_guide.dart';

class ToggleButtonElement extends StatelessWidget {
  final String label;
  final double? fixedWidth;
  final double? horizontalPadding;
  final double? verticalPadding;
  late double _horizontalPadding;
  late double _verticalPadding;

  ToggleButtonElement(this.label,
      {this.fixedWidth, this.horizontalPadding, this.verticalPadding}) {
    if (horizontalPadding == null) {
      _horizontalPadding = proportionateScreenWidth(20.0);
    }
    if (verticalPadding == null) {
      _verticalPadding = proportionateScreenHeight(16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _horizontalPadding, vertical: _verticalPadding),
        child: Center(
          child: Text(
            label,
          ),
        ),
      ),
      width: fixedWidth,
    );
  }
}
