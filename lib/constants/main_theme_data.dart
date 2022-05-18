import 'package:flutter/material.dart';
import 'package:linum/constants/main_text_theme.dart';

class MainThemeData {
  static final ThemeData lightTheme = ThemeData(
    //This is the colorScheme where we store the colors
    //the names should be self explaining
    //all those that are not custom are just fillers as ColorScheme lists
    //them all as required

    //use like this: Theme.of(context).colorScheme.NAME_OF_COLOR_STYLE
    colorScheme: const ColorScheme(
      primary: Color(0xFF97BC4E),
      primaryContainer: Colors.green,
      secondary: Color(0xFF505050),
      secondaryContainer: Colors.white,
      tertiary: Color(0xFFC1E695),
      tertiaryContainer: Color(0xFF808080),
      surface: Color(0xFFC1E695),
      background: Color(0xFFFAFAFA),
      error: Color(0xFFEB5757),
      errorContainer: Color.fromARGB(255, 250, 171, 171),
      onPrimary: Color(0xFFFAFAFA),
      onSecondary: Color(0xFFFAFAFA),
      onSurface: Color(0xFF505050),
      onBackground: Colors.black12,
      onError: Colors.teal,
      brightness: Brightness.light,
    ),

    // This is the generic textTheme where we store most basic applications
    // of different text styles. The names should be self-explaining.
    //use like this: Theme.of(context).textTheme.THEME_TYPE

    //we should discuss as whether to augment bis by adding an own @TODO
    // e.g. for the HEADLINER function
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Colors.transparent,
    ),
    textTheme: MainTextTheme.lightTheme,
  );
}
