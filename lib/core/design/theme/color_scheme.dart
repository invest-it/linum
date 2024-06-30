import 'package:flutter/material.dart';

class LinumColorScheme {
  static ColorScheme light() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF97BC4E),
      primaryContainer: Colors.green,
      secondary: Color(0xFF505050),
      secondaryContainer: Colors.white,
      tertiary: Color(0xFFC1E695),
      tertiaryContainer: Color(0xFF808080),
      surface: Color(0xFFFAFAFA),
      // background: const Color(0xFFe6e0e9),
      error: Color(0xFFEB5757),
      errorContainer: Color.fromARGB(255, 250, 171, 171),
      onPrimary: Color(0xFFFAFAFA),
      onSecondary: Color(0xFFFAFAFA),
      onSurface: Color(0xFF505050),
      // onBackground: const Color(0xFF79747E),
      onError: Colors.teal,
    );
  }
}
