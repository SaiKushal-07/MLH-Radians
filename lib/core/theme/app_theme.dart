// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:startupapp/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.accent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
        surface: AppColors.card,
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }
}