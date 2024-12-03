import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static ThemeData get lightTheme {
    final baseTheme = FlexThemeData.light(scheme: FlexScheme.mango);
    return baseTheme.copyWith(
        textTheme: GoogleFonts.cabinTextTheme(baseTheme.textTheme));
  }

  static ThemeData get darkTheme {
    final baseTheme = FlexThemeData.dark(scheme: FlexScheme.mango);
    return baseTheme.copyWith(
        textTheme: GoogleFonts.cabinTextTheme(baseTheme.textTheme));
  }
}
