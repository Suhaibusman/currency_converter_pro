import 'package:flutter/material.dart';

enum AppThemeMode {
  neonPulse,
  midnightLuxe,
  frostAura,
  saharaGlow,
  emeraldWave,
  goldenHorizon,
  oceanPrism,
  sunsetEmber,
  skyNova,
  systemSync,
  custom,
}

class ThemeConstants {
  static const Map<AppThemeMode, ThemeColors> themes = {
    AppThemeMode.neonPulse: ThemeColors(
      primary: Color(0xFFFF006E),
      secondary: Color(0xFF8338EC),
      background: Color(0xFF0A0E27),
      surface: Color(0xFF1A1F3A),
      accent: Color(0xFFFFBE0B),
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xFFB8C5D6),
      success: Color(0xFF06FFA5),
      error: Color(0xFFFF0054),
      warning: Color(0xFFFFB800),
    ),
    AppThemeMode.midnightLuxe: ThemeColors(
      primary: Color(0xFF6C63FF),
      secondary: Color(0xFF9D4EDD),
      background: Color(0xFF0D0D1E),
      surface: Color(0xFF1C1C2E),
      accent: Color(0xFFFFD60A),
      textPrimary: Color(0xFFF8F9FA),
      textSecondary: Color(0xFFADB5BD),
      success: Color(0xFF00D9B5),
      error: Color(0xFFFF006E),
      warning: Color(0xFFFFBA08),
    ),
    AppThemeMode.frostAura: ThemeColors(
      primary: Color(0xFF00B4D8),
      secondary: Color(0xFF0077B6),
      background: Color(0xFFE8F4F8),
      surface: Color(0xFFFFFFFF),
      accent: Color(0xFF90E0EF),
      textPrimary: Color(0xFF03045E),
      textSecondary: Color(0xFF023E8A),
      success: Color(0xFF06D6A0),
      error: Color(0xFFEF476F),
      warning: Color(0xFFFFD166),
    ),
    AppThemeMode.saharaGlow: ThemeColors(
      primary: Color(0xFFD4A574),
      secondary: Color(0xFFB8860B),
      background: Color(0xFFFFF8E7),
      surface: Color(0xFFFFFBF0),
      accent: Color(0xFFCD853F),
      textPrimary: Color(0xFF3E2723),
      textSecondary: Color(0xFF5D4037),
      success: Color(0xFF66BB6A),
      error: Color(0xFFE53935),
      warning: Color(0xFFFFA726),
    ),
    AppThemeMode.emeraldWave: ThemeColors(
      primary: Color(0xFF10B981),
      secondary: Color(0xFF059669),
      background: Color(0xFF064E3B),
      surface: Color(0xFF065F46),
      accent: Color(0xFF34D399),
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xFFD1FAE5),
      success: Color(0xFF22C55E),
      error: Color(0xFFEF4444),
      warning: Color(0xFFF59E0B),
    ),
    AppThemeMode.goldenHorizon: ThemeColors(
      primary: Color(0xFFF59E0B),
      secondary: Color(0xFFD97706),
      background: Color(0xFFFFFBEB),
      surface: Color(0xFFFFFBEB),
      accent: Color(0xFFFBBF24),
      textPrimary: Color(0xFF78350F),
      textSecondary: Color(0xFF92400E),
      success: Color(0xFF10B981),
      error: Color(0xFFDC2626),
      warning: Color(0xFFF59E0B),
    ),
    AppThemeMode.oceanPrism: ThemeColors(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF2563EB),
      background: Color(0xFF0F172A),
      surface: Color(0xFF1E293B),
      accent: Color(0xFF60A5FA),
      textPrimary: Color(0xFFF1F5F9),
      textSecondary: Color(0xFFCBD5E1),
      success: Color(0xFF10B981),
      error: Color(0xFFEF4444),
      warning: Color(0xFFF59E0B),
    ),
    AppThemeMode.sunsetEmber: ThemeColors(
      primary: Color(0xFFFF6B35),
      secondary: Color(0xFFE63946),
      background: Color(0xFF2B2D42),
      surface: Color(0xFF3D405B),
      accent: Color(0xFFFCAA67),
      textPrimary: Color(0xFFF8F9FA),
      textSecondary: Color(0xFFDEE2E6),
      success: Color(0xFF06D6A0),
      error: Color(0xFFEF476F),
      warning: Color(0xFFFFD166),
    ),
    AppThemeMode.skyNova: ThemeColors(
      primary: Color(0xFF38BDF8),
      secondary: Color(0xFF0EA5E9),
      background: Color(0xFFF0F9FF),
      surface: Color(0xFFFFFFFF),
      accent: Color(0xFF7DD3FC),
      textPrimary: Color(0xFF0C4A6E),
      textSecondary: Color(0xFF075985),
      success: Color(0xFF22C55E),
      error: Color(0xFFEF4444),
      warning: Color(0xFFF59E0B),
    ),
  };

  static ThemeColors getSystemTheme(Brightness brightness) {
    return brightness == Brightness.dark
        ? themes[AppThemeMode.midnightLuxe]!
        : themes[AppThemeMode.frostAura]!;
  }
}

class ThemeColors {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color error;
  final Color warning;

  const ThemeColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.error,
    required this.warning,
  });
}
