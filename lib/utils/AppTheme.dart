import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static ThemeData themeData(Brightness themeMode) =>
      ThemeData(
        brightness: themeMode,
        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
        primarySwatch: Colors.blue,
      );
}