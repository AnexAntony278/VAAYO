import 'package:vaayo/src/constants/color.dart';
import 'package:flutter/material.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._(); //avoid create instances

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(),
      foregroundColor: vSecondaryColor,
      side: BorderSide(color: vSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: 15.0),
    ),
  );
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(),
      foregroundColor: vWhiteColor,
      side: BorderSide(color: vWhiteColor),
      padding: EdgeInsets.symmetric(vertical: 15.0),
    ),
  );
}
