import 'package:flutter/material.dart';

/// Semantic colors and palettes for CampusLoop.
class AppColors {
  AppColors._();

  // Primary brand palette (Indigo)
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryContainer = Color(0xFFEEF2FF);
  static const Color onPrimaryContainer = Color(0xFF312E81);

  // Secondary brand palette (Teal)
  static const Color secondary = Color(0xFF0D9488);
  static const Color secondaryContainer = Color(0xFFCCFBF1);
  static const Color onSecondaryContainer = Color(0xFF115E59);

  // Activity Kind: Campus Event (Violet)
  static const Color eventPrimary = Color(0xFF7C3AED);
  static const Color eventBackground = Color(0xFFF5F3FF);
  static const Color eventBorder = Color(0xFFDDD6FE);

  // Activity Kind: Peer-led Study Session (Amber / Warm Orange)
  static const Color studyPrimary = Color(0xFFD97706);
  static const Color studyBackground = Color(0xFFFFFBEB);
  static const Color studyBorder = Color(0xFFFDE68A);

  // Status colors
  static const Color active = Color(0xFF059669);
  static const Color activeBackground = Color(0xFFECFDF5);
  static const Color cancelled = Color(0xFFDC2626);
  static const Color cancelledBackground = Color(0xFFFEF2F2);
  static const Color full = Color(0xFFE11D48);
  static const Color fullBackground = Color(0xFFFFF1F2);

  // Light theme neutrals
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);

  // Dark theme neutrals
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);
}
