import 'package:currency_converter_pro/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/theme_constants.dart';
import '../../data/datasources/local/settings_local_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import 'currency_provider.dart';


final currentThemeProvider = FutureProvider<ThemeData>((ref) async {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  
  final themeResult = await settingsRepo.getTheme();
  final colorResult = await settingsRepo.getCustomColor();
  final fontSizeResult = await settingsRepo.getFontSize();
  
  return themeResult.fold(
    (failure) => AppTheme.getTheme('midnight_luxe'),
    (themeName) => colorResult.fold(
      (failure) => AppTheme.getTheme(themeName),
      (customColor) => fontSizeResult.fold(
        (failure) => AppTheme.getTheme(themeName, customColor: Color(customColor)),
        (fontSize) => AppTheme.getTheme(
          themeName,
          customColor: Color(customColor),
          fontSize: fontSize,
        ),
      ),
    ),
  );
});
// Settings Repository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    SettingsLocalDataSourceImpl(ref.watch(sharedPreferencesProvider)),
  );
});

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>(
  (ref) {
    return ThemeModeNotifier(ref.watch(settingsRepositoryProvider));
  },
);

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  final SettingsRepository repository;

  ThemeModeNotifier(this.repository) : super(AppThemeMode.systemSync) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final result = await repository.getTheme();
    result.fold(
      (failure) => null,
      (themeName) {
        state = AppThemeMode.values.firstWhere(
          (mode) => mode.name == themeName,
          orElse: () => AppThemeMode.systemSync,
        );
      },
    );
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    await repository.setTheme(mode.name);
  }
}

// Custom Color Provider
final customColorProvider = StateNotifierProvider<CustomColorNotifier, Color>(
  (ref) {
    return CustomColorNotifier(ref.watch(settingsRepositoryProvider));
  },
);

class CustomColorNotifier extends StateNotifier<Color> {
  final SettingsRepository repository;

  CustomColorNotifier(this.repository) : super(const Color(0xFF6C63FF)) {
    _loadColor();
  }

  Future<void> _loadColor() async {
    final result = await repository.getCustomColor();
    result.fold(
      (failure) => null,
      (colorValue) {
        state = Color(colorValue);
      },
    );
  }

  Future<void> setColor(Color color) async {
    state = color;
    await repository.setCustomColor(color.value);
  }
}

// Theme Data Provider
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final customColor = ref.watch(customColorProvider);
  
  ThemeColors colors;
  
  if (themeMode == AppThemeMode.systemSync) {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    colors = ThemeConstants.getSystemTheme(brightness);
  } else if (themeMode == AppThemeMode.custom) {
    colors = ThemeColors(
      primary: customColor,
      secondary: customColor.withOpacity(0.8),
      background: const Color(0xFF0D0D1E),
      surface: const Color(0xFF1C1C2E),
      accent: customColor.withOpacity(0.6),
      textPrimary: const Color(0xFFF8F9FA),
      textSecondary: const Color(0xFFADB5BD),
      success: const Color(0xFF00D9B5),
      error: const Color(0xFFFF006E),
      warning: const Color(0xFFFFBA08),
    );
  } else {
    colors = ThemeConstants.themes[themeMode]!;
  }
  
  return ThemeData(
    useMaterial3: true,
    brightness: _getBrightness(colors),
    colorScheme: ColorScheme(
      brightness: _getBrightness(colors),
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
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.textPrimary,
      elevation: 0,
    ),
  );
});

Brightness _getBrightness(ThemeColors colors) {
  return colors.background.computeLuminance() > 0.5 
      ? Brightness.light 
      : Brightness.dark;
}