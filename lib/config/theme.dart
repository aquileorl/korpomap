import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF8B5CF6);    // Morado
  static const secondary = Color(0xFF22C55E);  // Verde
  static const background = Color(0xFFFFFFFF); // Fondo blanco
  static const card = Color(0xFFF4F4F5);       // Cards gris claro
  static const textPrimary = Color(0xFF18181B);
  static const textSecondary = Color(0xFF71717A);
}

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.card,
      elevation: 0,
    ),
  );
}
