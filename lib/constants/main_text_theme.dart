//  Main Text Theme - Constants File containing the entire textTheme used in main.dart
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainTextTheme {
  static final TextTheme lightTheme = TextTheme(
    headline1: GoogleFonts.dmSans(
      fontSize: 39.81,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.5,
      color: const Color(0xFF303030),
    ),
    headline2: GoogleFonts.dmSans(
      fontSize: 33.18,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF303030),
    ),
    headline3: GoogleFonts.dmSans(
      fontSize: 27.65,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF303030),
    ),
    headline4: GoogleFonts.dmSans(
      fontSize: 23.04,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.25,
      color: const Color(0xFF303030),
    ),
    headline5: GoogleFonts.dmSans(
      fontSize: 19.2,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF202020),
    ),

    //REPLACEMENT FOUND --> displayMedium
    headline6: GoogleFonts.dmSans(
      fontSize: 84,
      letterSpacing: -1.5,
      fontWeight: FontWeight.w700,
      color: const Color(0xFFC1E695),
    ),
    bodyText1: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.16,
    ),
    bodyText2: GoogleFonts.dmSans(
      fontSize: 13.33,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.08,
    ),

    //REPLACEMENT FOUND --> labelSmall
    overline: GoogleFonts.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
      color: const Color(0xFF505050),
    ),

    //REPLACEMENT FOUND --> labelLarge
    button: GoogleFonts.dmSans(
      fontSize: 19.2,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: const Color(0xFFFAFAFA),
    ),
  );

//PREP FOR NEW THEME

  // static final TextTheme lightThemeNew = TextTheme(

  //   //DISPLAY FONTS - Largest Set of Fonts, Heavy Weight, only use for very distinct purposes.
  //   displayLarge: ,

  //   displayMedium: GoogleFonts.dmSans(
  //     fontSize: 84,
  //     letterSpacing: -1.5,
  //     fontWeight: FontWeight.w700,
  //     color: const Color(0xFFC1E695),
  //   ), //aka headline6 before the change

  //   displaySmall: ,

  //   //HEADLINE FONTS - use for tab headlines and larger titles.
  //   headlineLarge: ,
  //   headlineMedium: ,
  //   headlineSmall: ,

  //   //TITLE FONTS - use for section and navigation headings.
  //   titleLarge: ,
  //   titleMedium: ,
  //   titleSmall: ,

  //   //LABEL FONTS - use for identification of cards, chips and the like.

  //   labelLarge: GoogleFonts.dmSans(
  //     fontSize: 19.2,
  //     fontWeight: FontWeight.w500,
  //     letterSpacing: 0.15,
  //     color: const Color(0xFFFAFAFA),
  //   ), //aka button before the change

  //   labelMedium: ,

  //   labelSmall: GoogleFonts.dmSans(
  //     fontSize: 10,
  //     fontWeight: FontWeight.w700,
  //     letterSpacing: 1.5,
  //     color: const Color(0xFF505050),
  //   ), //aka overline before the change

  //   //BODY FONTS - Usual set of paragraph fonts. Use larger ones to make typography stand out, smaller ones for added paraphrases.
  //   bodyLarge: ,
  //   bodyMedium: ,
  //   bodySmall: ,

  // );
}
