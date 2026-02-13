import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getTheme(String themeName, {Color? customColor, double fontSize = 16.0}) {
    switch (themeName) {
      case 'neon_pulse':
        return _neonPulse(fontSize);
      case 'midnight_luxe':
        return _midnightLuxe(fontSize);
      case 'frost_aura':
        return _frostAura(fontSize);
      case 'sahara_glow':
        return _saharaGlow(fontSize);
      case 'emerald_wave':
        return _emeraldWave(fontSize);
      case 'golden_horizon':
        return _goldenHorizon(fontSize);
      case 'ocean_prism':
        return _oceanPrism(fontSize);
      case 'sunset_ember':
        return _sunsetEmber(fontSize);
      case 'sky_nova':
        return _skyNova(fontSize);
      case 'system_sync':
        return _systemSync(fontSize);
      case 'custom':
        return _customTheme(customColor ?? Colors.purple, fontSize);
      default:
        return _midnightLuxe(fontSize);
    }
  }

  static ThemeData _neonPulse(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF00FFF0),
      scaffoldBackgroundColor: const Color(0xFF0A0E27),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFF0),
        secondary: Color(0xFFFF006E),
        surface: Color(0xFF1A1F3A),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1F3A),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0E27),
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00FFF0),
          foregroundColor: const Color(0xFF000000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1F3A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00FFF0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A2F4A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00FFF0), width: 2),
        ),
      ),
    );
  }

  static ThemeData _midnightLuxe(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF6C63FF),
      scaffoldBackgroundColor: const Color(0xFF0F0F23),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6C63FF),
        secondary: Color(0xFFFF6584),
        surface: Color(0xFF1C1C3A),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1C1C3A),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F0F23),
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1C1C3A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2C2C4A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
      ),
    );
  }

  static ThemeData _frostAura(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF4FC3F7),
      scaffoldBackgroundColor: const Color(0xFFF0F8FF),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4FC3F7),
        secondary: Color(0xFF80DEEA),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onSurface: Color(0xFF000000),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF0F8FF),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Color(0xFF000000),
      ),
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4FC3F7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4FC3F7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4FC3F7), width: 2),
        ),
      ),
    );
  }

  static ThemeData _saharaGlow(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFFFFB74D),
      scaffoldBackgroundColor: const Color(0xFFFFF8E1),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFB74D),
        secondary: Color(0xFFFFE082),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onSurface: Color(0xFF000000),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFF8E1),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Color(0xFF000000),
      ),
      textTheme: GoogleFonts.latoTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB74D),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData _emeraldWave(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF00C853),
      scaffoldBackgroundColor: const Color(0xFF0D1B2A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00C853),
        secondary: Color(0xFF69F0AE),
        surface: Color(0xFF1B263B),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1B263B),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D1B2A),
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C853),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData _goldenHorizon(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFFFFD700),
      scaffoldBackgroundColor: const Color(0xFFFFFDE7),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFD700),
        secondary: Color(0xFFFFECB3),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onSurface: Color(0xFF000000),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFDE7),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Color(0xFF000000),
      ),
      textTheme: GoogleFonts.nunitoTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData _oceanPrism(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0277BD),
      scaffoldBackgroundColor: const Color(0xFF01579B),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0277BD),
        secondary: Color(0xFF29B6F6),
        surface: Color(0xFF0288D1),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF0288D1),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF01579B),
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.ralewayTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF29B6F6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData _sunsetEmber(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFFF5722),
      scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF5722),
        secondary: Color(0xFFFF7043),
        surface: Color(0xFF16213E),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF16213E),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A2E),
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.openSansTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5722),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData _skyNova(double fontSize) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF2196F3),
      scaffoldBackgroundColor: const Color(0xFFE3F2FD),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2196F3),
        secondary: Color(0xFF64B5F6),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFF000000),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFE3F2FD),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Color(0xFF000000),
      ),
      textTheme: GoogleFonts.sourceSansProTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData _systemSync(double fontSize) {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    
    if (brightness == Brightness.dark) {
      return _midnightLuxe(fontSize);
    } else {
      return _skyNova(fontSize);
    }
  }

  static ThemeData _customTheme(Color primaryColor, double fontSize) {
    final isDark = primaryColor.computeLuminance() < 0.5;
    
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: primaryColor,
              secondary: primaryColor.withOpacity(0.7),
              surface: const Color(0xFF1E1E1E),
            )
          : ColorScheme.light(
              primary: primaryColor,
              secondary: primaryColor.withOpacity(0.7),
              surface: Colors.white,
            ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: isDark ? 6 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: isDark ? Colors.white : Colors.black,
        displayColor: isDark ? Colors.white : Colors.black,
      ).copyWith(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: isDark ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static List<Map<String, dynamic>> getAllThemes() {
    return [
      {'name': 'neon_pulse', 'display': 'Neon Pulse', 'icon': Icons.flash_on, 'color': const Color(0xFF00FFF0)},
      {'name': 'midnight_luxe', 'display': 'Midnight Luxe', 'icon': Icons.nightlight_round, 'color': const Color(0xFF6C63FF)},
      {'name': 'frost_aura', 'display': 'Frost Aura', 'icon': Icons.ac_unit, 'color': const Color(0xFF4FC3F7)},
      {'name': 'sahara_glow', 'display': 'Sahara Glow', 'icon': Icons.wb_sunny, 'color': const Color(0xFFFFB74D)},
      {'name': 'emerald_wave', 'display': 'Emerald Wave', 'icon': Icons.waves, 'color': const Color(0xFF00C853)},
      {'name': 'golden_horizon', 'display': 'Golden Horizon', 'icon': Icons.wb_twilight, 'color': const Color(0xFFFFD700)},
      {'name': 'ocean_prism', 'display': 'Ocean Prism', 'icon': Icons.water, 'color': const Color(0xFF0277BD)},
      {'name': 'sunset_ember', 'display': 'Sunset Ember', 'icon': Icons.local_fire_department, 'color': const Color(0xFFFF5722)},
      {'name': 'sky_nova', 'display': 'Sky Nova', 'icon': Icons.cloud, 'color': const Color(0xFF2196F3)},
      {'name': 'system_sync', 'display': 'System Sync', 'icon': Icons.brightness_auto, 'color': Colors.grey},
      {'name': 'custom', 'display': 'Custom', 'icon': Icons.palette, 'color': Colors.purple},
    ];
  }
}