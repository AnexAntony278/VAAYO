import 'package:vaayo/src/constants/color.dart';
import 'package:flutter/material.dart';

class VElevatedButtonTheme {
  VElevatedButtonTheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: vWhiteColor,
      backgroundColor: vSecondaryColor,
      side: BorderSide(color: vSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: 15.0),
    ),
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: vSecondaryColor,
      backgroundColor: vWhiteColor,
      side: BorderSide(color: vSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: 15.0),
    ),
  );
}
