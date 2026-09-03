// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // New platform naming
  static const Color background = Color(0xFF0F172A);
  static const Color card = Color(0xFF1E293B);
  static const Color accent = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF22C55E);

  // Legacy Veto idea_validation naming (aliases onto the same palette)
  static const Color bgPrimary = background;
  static const Color surfaceCard = card;
  static const Color surfaceCardElevated = Color(0xFF263449);
  static const Color accentGold = accent;
  static const Color pivotGold = accent;
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white60;
  static const Color divider = Colors.white12;
  static const Color collisionRed = Color(0xFFEF4444);
  static const Color flawAmber = Color(0xFFF59E0B);
  static const Color successGreen = Color(0xFF22C55E);
}