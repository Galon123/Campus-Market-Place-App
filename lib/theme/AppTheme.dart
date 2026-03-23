import 'package:e_commerce_refactor/theme/constants.dart';
import 'package:flutter/material.dart';

class Apptheme {

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: LightModeColor.baseBackground,
    colorScheme: const ColorScheme.light(
      primary: LightModeColor.brand,
      secondary: LightModeColor.subtle,
      surfaceBright: LightModeColor.lowBackground,
      surface: LightModeColor.midBackground,
      surfaceDim: LightModeColor.highBackground,
      error: LightModeColor.errorColor,
      onPrimary: LightModeColor.textPrimary,
      onSurface: LightModeColor.textPrimary,
      onError: Colors.white
    ),
    textTheme: const TextTheme(
      labelMedium: TextStyle(color: LightModeColor.textSecondary),
      titleLarge: TextStyle(color: LightModeColor.textPrimary),
      titleMedium: TextStyle(color: LightModeColor.textSecondary),
      titleSmall: TextStyle(color: LightModeColor.textMuted),
      bodyLarge: TextStyle(color: LightModeColor.textPrimary),
      bodyMedium: TextStyle(color: LightModeColor.textSecondary),
      bodySmall: TextStyle(color: LightModeColor.textMuted)
    )
  );


  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: DarkModeColor.baseBackground,
    colorScheme: const ColorScheme.dark(
      primary: DarkModeColor.brand,
      secondary: DarkModeColor.subtle,
      surface: DarkModeColor.lowBackground,
      error: DarkModeColor.errorColor,
      onPrimary: DarkModeColor.textPrimary,
      onSurface: DarkModeColor.textPrimary,
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DarkModeColor.textPrimary),
      bodyMedium: TextStyle(color: DarkModeColor.textSecondary),
      bodySmall: TextStyle(color: DarkModeColor.textMuted),
    ),
  );
}

extension AppColorScheme on ColorScheme {

  Color get success => brightness == Brightness.dark
    ? DarkModeColor.successColor
    : LightModeColor.successColor;
  
  Color get warning => brightness == Brightness.dark
    ? DarkModeColor.warningColor
    : LightModeColor.warningColor;

}
