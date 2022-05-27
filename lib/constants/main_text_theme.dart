//  Main Text Theme - Constants File containing the entire textTheme used in main.dart
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

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
    //the text theme for the big headlines telling the page's name
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
    overline: GoogleFonts.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
      color: const Color(0xFF505050),
    ),
    button: GoogleFonts.dmSans(
      fontSize: 19.2,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: const Color(0xFFFAFAFA),
    ),
  );
}
