import 'package:vaayo/src/constants/color.dart';
import 'package:flutter/material.dart';

class VElevatedButtonTheme {
  VElevatedButtonTheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      foregroundColor: vWhiteColor,
      backgroundColor: vSecondaryColor,
      side: const BorderSide(color: vSecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: 15.0),
    ),
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      foregroundColor: vSecondaryColor,
      backgroundColor: vWhiteColor,
      side: const BorderSide(color: vSecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: 15.0),
    ),
  );
}
