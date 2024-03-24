import 'package:vaayo/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:vaayo/src/utils/theme/widget_themes/outline_button_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TAppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TextTheme(
        bodyLarge: GoogleFonts.montserrat(
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: Colors.black54,
          fontSize: 24,
        ),
        bodySmall: GoogleFonts.poppins(
          color: Colors.black38,
          fontSize: 18,
        )),
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
        bodyLarge: GoogleFonts.montserrat(
          color: Colors.white70,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: Colors.white54,
          fontSize: 24,
        ),
        bodySmall: GoogleFonts.poppins(
          color: Colors.white30,
          fontSize: 18,
        )),
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
  );
}
