import 'package:flutter/material.dart';
import 'package:linum/core/design/theme/color_scheme.dart';
import 'package:linum/core/design/theme/text_theme.dart';

class LinumFilledButtonTheme {

  static TextStyle _getTextStyle(Set<MaterialState> states) {
    final baseStyle = LinumTextTheme.lightTheme.labelMedium ?? const TextStyle();

    if (states.contains(MaterialState.disabled)) {
      return baseStyle.copyWith(
        color: LinumColorScheme.light().onSurface.withOpacity(0.38),
      );
    }
    return baseStyle.copyWith(
      color: Colors.white,
    );
  }

  static Color _getBackgroundColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return LinumColorScheme.light().onSurface.withOpacity(0.12);
    }
    
    return LinumColorScheme.light().primary;
  }

  static FilledButtonThemeData light() {
    return FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith(_getTextStyle),
        backgroundColor: MaterialStateProperty.resolveWith(_getBackgroundColor),
      ),
    );
  }
}