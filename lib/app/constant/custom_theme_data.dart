import 'package:flutter/material.dart';

final primaryColor = Colors.grey.shade50;
final primaryColorLight = Colors.white;
final primaryColorDark = Colors.grey.shade300;
final primaryTextColor = Colors.black;
final secondaryColor = Colors.blue.shade800;
final secondaryColorLight = Colors.blue.shade700;
final secondaryColorDark = Colors.blue.shade900;
final secondaryTextColor = Colors.white;

final customThemeData = ThemeData(
  appBarTheme: AppBarTheme(
    elevation: 1,
    centerTitle: true,
  ),
  primaryColor: primaryColorLight,
  scaffoldBackgroundColor: primaryColor,
  accentColor: secondaryColor,
  buttonTheme: ButtonThemeData(
    buttonColor: secondaryColor,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: secondaryColorLight,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: secondaryColor,
    ),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    selectedBorderColor: secondaryColor,
    selectedColor: secondaryTextColor,
    disabledColor: primaryColorLight,
    fillColor: secondaryColor,
  ),
);
