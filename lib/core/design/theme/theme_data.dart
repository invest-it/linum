//  Main Theme Data - Contains the entire MaterialTheme used in main.dart
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/core/design/theme/color_scheme.dart';
import 'package:linum/core/design/theme/filled_button_theme.dart';
import 'package:linum/core/design/theme/text_theme.dart';



class LinumTheme {

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      //use like this: Theme.of(context).colorScheme.NAME_OF_COLOR_STYLE
      colorScheme: LinumColorScheme.light(),

      // This is the generic textTheme where we store most basic applications
      // of different text styles. The names should be self-explaining.
      // use like this: Theme.of(context).textTheme.THEME_TYPE

      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Colors.transparent,
      ),

      textTheme: LinumTextTheme.lightTheme,

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),


      filledButtonTheme: LinumFilledButtonTheme.light()

    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme(
        primary: Color(0xFF97BC4E),
        primaryContainer: Colors.green,
        secondary: Color(0xFF505050),
        secondaryContainer: Colors.white,
        tertiary: Color(0xFFC1E695),
        tertiaryContainer: Color(0xFF808080),
        surface: Color(0xFFe6e0e9),
        background: Color(0xFFFAFAFA),
        error: Color(0xFFEB5757),
        errorContainer: Color.fromARGB(255, 250, 171, 171),
        onPrimary: Color(0xFFFAFAFA),
        onSecondary: Color(0xFFFAFAFA),
        onSurface: Color(0xFF505050),
        onBackground: Color(0xFF79747E),
        onError: Colors.teal,
        brightness: Brightness.light,
      ),

      // This is the generic textTheme where we store most basic applications
      // of different text styles. The names should be self-explaining.
      //use like this: Theme.of(context).textTheme.THEME_TYPE

      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Colors.transparent,
      ),

      textTheme: LinumTextTheme.lightTheme,
    );
  }
}
