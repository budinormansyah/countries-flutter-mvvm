import 'package:countries/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 3),
    borderRadius: BorderRadius.circular(10),
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.darkBackgroundColor,
    cardColor: AppPalette.darkCardColor,
    colorScheme: const ColorScheme.dark(primary: AppPalette.primaryAccent),
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'ComicRelief',
      bodyColor: AppPalette.whiteColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(AppPalette.borderColor),
      focusedBorder: _border(AppPalette.gradient2),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppPalette.darkBackgroundColor,
    ),
  );
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalette.lightBackgroundColor,
    cardColor: AppPalette.lightCardColor,
    colorScheme: const ColorScheme.light(primary: AppPalette.primaryAccent),
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'ComicRelief',
      bodyColor: AppPalette.primaryTextColor,
      displayColor: AppPalette.primaryTextColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(AppPalette.borderColor),
      focusedBorder: _border(AppPalette.gradient2),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppPalette.lightBackgroundColor,
    ),
  );
}
