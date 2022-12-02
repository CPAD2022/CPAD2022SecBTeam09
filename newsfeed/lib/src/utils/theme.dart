import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';

final ThemeData kLightTheme = _buildLightTheme();

final TextTheme textThemeLight =
    GoogleFonts.latoTextTheme(ThemeData.light().textTheme).copyWith(
  headline4: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    color: Colors.black,
  ),
  subtitle2: TextStyle(
    color: HexColor.fromHex(ColorConstants.primaryColor),
  ),
);

final TextTheme textThemeDark =
    GoogleFonts.latoTextTheme(ThemeData.dark().textTheme).copyWith(
  headline4: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    color: Colors.white,
  ),
  subtitle2: TextStyle(
    color: HexColor.fromHex(ColorConstants.primaryColor),
  ),
);

ThemeData _buildLightTheme() {
  return ThemeData(brightness: Brightness.light, textTheme: textThemeLight);
}

final ThemeData kDarkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  return ThemeData(brightness: Brightness.dark, textTheme: textThemeDark);
}
