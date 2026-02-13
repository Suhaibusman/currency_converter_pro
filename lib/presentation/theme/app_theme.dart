import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/theme_constants.dart';

class AppTheme {
  static ThemeData buildTheme(ThemeColors colors, double fontSize) {
    final brightness = colors.background.computeLuminance() > 0.5 
        ? Brightness.light 
        : Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.textPrimary,
        secondary: colors.secondary,
        onSecondary: colors.textPrimary,
        error: colors.error,
        onError: colors.textPrimary,
        surface: colors.surface,
        onSurface: colors.textPrimary,
      ),
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.surface,
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize, color: colors.textPrimary),
        bodyMedium: TextStyle(fontSize: fontSize, color: colors.textPrimary),
        bodySmall: TextStyle(fontSize: fontSize - 2, color: colors.textSecondary),
        titleLarge: TextStyle(fontSize: fontSize + 8, fontWeight: FontWeight.bold, color: colors.textPrimary),
        titleMedium: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.w600, color: colors.textPrimary),
        titleSmall: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.w500, color: colors.textPrimary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: fontSize + 6,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
      ),
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.textPrimary,
      ),
    );
  }

  static BoxDecoration glassmorphism(ThemeColors colors) {
    return BoxDecoration(
      color: colors.surface.withOpacity(0.7),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: colors.textPrimary.withOpacity(0.1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: colors.primary.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}