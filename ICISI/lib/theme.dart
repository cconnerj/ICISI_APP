import 'package:flutter/material.dart';

final ThemeData icisiThemeData = new ThemeData(
    brightness: Brightness.light,
    primarySwatch: CompanyColors.iBlue,
    primaryColor: CompanyColors.iBlue,
    primaryColorBrightness: Brightness.light,
    accentColor: CompanyColors.coolGrey,
    accentColorBrightness: Brightness.light);

class CompanyColors {
  CompanyColors._();

  static const _greyPrimaryValue = 0xFF7A7D81;

  static const MaterialColor coolGrey = const MaterialColor(
    _greyPrimaryValue,
    const <int, Color>{
      50: const Color(0xFF7A7D81),
      100: const Color(0xFF7A7D81),
      200: const Color(0xFF7A7D81),
      300: const Color(0xFF7A7D81),
      400: const Color(0xFF7A7D81),
      500: const Color(0xFF7A7D81),
      600: const Color(0xFF7A7D81),
      700: const Color(0xFF7A7D81),
      800: const Color(0xFF7A7D81),
      900: const Color(0xFF7A7D81),
    },
  );

  static const _iBluePrimaryValue = 0XFF97C1DF;

  static const MaterialColor iBlue = const MaterialColor(
    _iBluePrimaryValue,
    const <int, Color>{
      50: const Color(0xFF97C1DF),
      100: const Color(0xFF97C1DF),
      200: const Color(0xFF97C1DF),
      300: const Color(0xFF97C1DF),
      400: const Color(0xFF97C1DF),
      500: const Color(0xFF97C1DF),
      600: const Color(0xFF97C1DF),
      700: const Color(0xFF97C1DF),
      800: const Color(0xFF97C1DF),
      900: const Color(0xFF97C1DF),
    },
  );
}
