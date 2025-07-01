import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();

  static const primaryColor = Color(0xffFFFFFF);
  static const secondaryColor = Color(0xff015697);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: primaryColor,
  );

  static ThemeData darkTheme = ThemeData(brightness: Brightness.dark);
}
