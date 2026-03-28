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
      titleLarge: TextStyle(color: LightModeColor.textPrimary,fontWeight: FontWeight.bold, fontSize: 32),
      titleMedium: TextStyle(color: LightModeColor.textSecondary,fontWeight: FontWeight.bold, fontSize: 28),
      titleSmall: TextStyle(color: LightModeColor.textMuted,fontWeight: FontWeight.bold, fontSize: 24),
      bodyLarge: TextStyle(color: LightModeColor.textPrimary, fontSize: 20),
      bodyMedium: TextStyle(color: LightModeColor.textSecondary, fontSize: 16),
      bodySmall: TextStyle(color: LightModeColor.textMuted, fontSize: 12)
    ),
    iconTheme: const IconThemeData(
      color: LightModeColor.brand
    )
  );


  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: DarkModeColor.baseBackground,
    colorScheme: const ColorScheme.dark(
      primary: DarkModeColor.brand,
      secondary: DarkModeColor.subtle,
      surfaceBright: DarkModeColor.lowBackground,
      surface: DarkModeColor.midBackground,
      surfaceDim: DarkModeColor.highBackground,
      error: DarkModeColor.errorColor,
      onPrimary: DarkModeColor.textPrimary,
      onSurface: DarkModeColor.textPrimary,
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: DarkModeColor.textPrimary,fontWeight: FontWeight.bold, fontSize: 32),
      titleMedium: TextStyle(color: DarkModeColor.textSecondary,fontWeight: FontWeight.bold, fontSize: 28),
      titleSmall: TextStyle(color: DarkModeColor.textMuted,fontWeight: FontWeight.bold, fontSize: 24),
      bodyLarge: TextStyle(color: DarkModeColor.textPrimary, fontSize: 20),
      bodyMedium: TextStyle(color: DarkModeColor.textSecondary, fontSize: 16),
      bodySmall: TextStyle(color: DarkModeColor.textMuted, fontSize: 12),
    ),
    iconTheme: const IconThemeData(
      color: LightModeColor.subtle
    )
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

extension AppTextTheme on BuildContext {

  TextStyle get buttonText => TextStyle(
    color: Theme.of(this).colorScheme.secondary,
    fontSize: 24,
    fontWeight: FontWeight.w600
  );
}
