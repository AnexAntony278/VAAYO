import 'package:vaayo/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:vaayo/src/utils/theme/widget_themes/outline_button_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: "Montserrat", color: Colors.black87),
      bodyMedium: TextStyle(
          fontFamily: "Montserrat", color: Colors.black54, fontSize: 24),
      bodySmall: TextStyle(
          fontFamily: "Montserrat", color: Colors.black45, fontSize: 18),
    ),
    outlinedButtonTheme: VOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: VElevatedButtonTheme.lightElevatedButtonTheme,
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: "Montserrat", color: Colors.white70),
      bodyMedium: TextStyle(fontFamily: "Montserrat", color: Colors.white54),
      bodySmall: TextStyle(fontFamily: "Montserrat", color: Colors.white30),
    ),
    outlinedButtonTheme: VOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: VElevatedButtonTheme.darkElevatedButtonTheme,
  );
}
