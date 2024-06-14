import 'package:flutter/material.dart';

class LinumColorScheme {
  static ColorScheme light() {
    return ColorScheme.fromSeed(
      seedColor: const Color(0xFF97BC4E),
      primary: const Color(0xFF97BC4E),
      primaryContainer: Colors.green,
      secondary: const Color(0xFF505050),
      secondaryContainer: Colors.white,
      tertiary: const Color(0xFFC1E695),
      tertiaryContainer: const Color(0xFF808080),
      surface: const Color(0xFFe6e0e9),
      background: const Color(0xFFFAFAFA),
      error: const Color(0xFFEB5757),
      errorContainer: const Color.fromARGB(255, 250, 171, 171),
      onPrimary: const Color(0xFFFAFAFA),
      onSecondary: const Color(0xFFFAFAFA),
      onSurface: const Color(0xFF505050),
      onBackground: const Color(0xFF79747E),
      onError: Colors.teal,
    );
  }
}