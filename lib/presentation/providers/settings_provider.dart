import 'package:currency_converter_pro/data/datasources/local/settings_local_datasource.dart';
import 'package:currency_converter_pro/data/repositories/settings_repository_impl.dart';
import 'package:currency_converter_pro/presentation/providers/currency_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/settings_repository.dart';
import 'theme_provider.dart';


final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSourceImpl(ref.watch(sharedPreferencesProvider));
});

final settingsRepositoryProvider = Provider((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsLocalDataSourceProvider));
});

final baseCurrencyProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  final result = await repository.getBaseCurrency();
  return result.fold(
    (failure) => 'USD',
    (currency) => currency,
  );
});

final fontSizeProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  final result = await repository.getFontSize();
  return result.fold(
    (failure) => 16.0,
    (size) => size,
  );
});



class FontSizeNotifier extends StateNotifier<double> {
  final SettingsRepository repository;

  FontSizeNotifier(this.repository) : super(14.0) {
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final result = await repository.getFontSize();
    result.fold(
      (failure) => null,
      (size) => state = size,
    );
  }

  Future<void> setFontSize(double size) async {
    state = size;
    await repository.setFontSize(size);
  }
}

// Decimal Precision Provider
final decimalPrecisionProvider = 
    StateNotifierProvider<DecimalPrecisionNotifier, int>(
  (ref) {
    return DecimalPrecisionNotifier(ref.watch(settingsRepositoryProvider));
  },
);

class DecimalPrecisionNotifier extends StateNotifier<int> {
  final SettingsRepository repository;

  DecimalPrecisionNotifier(this.repository) : super(4) {
    _loadPrecision();
  }

  Future<void> _loadPrecision() async {
    final result = await repository.getDecimalPrecision();
    result.fold(
      (failure) => null,
      (precision) => state = precision,
    );
  }

  Future<void> setPrecision(int precision) async {
    state = precision;
    await repository.setDecimalPrecision(precision);
  }
}

// Rounding Mode Provider
final roundingModeProvider = StateNotifierProvider<RoundingModeNotifier, String>(
  (ref) {
    return RoundingModeNotifier(ref.watch(settingsRepositoryProvider));
  },
);

class RoundingModeNotifier extends StateNotifier<String> {
  final SettingsRepository repository;

  RoundingModeNotifier(this.repository) : super('halfUp') {
    _loadRoundingMode();
  }

  Future<void> _loadRoundingMode() async {
    final result = await repository.getRoundingMode();
    result.fold(
      (failure) => null,
      (mode) => state = mode,
    );
  }

  Future<void> setRoundingMode(String mode) async {
    state = mode;
    await repository.setRoundingMode(mode);
  }
}

// Biometric Enabled Provider
final biometricEnabledProvider = 
    StateNotifierProvider<BiometricEnabledNotifier, bool>(
  (ref) {
    return BiometricEnabledNotifier(ref.watch(settingsRepositoryProvider));
  },
);

class BiometricEnabledNotifier extends StateNotifier<bool> {
  final SettingsRepository repository;

  BiometricEnabledNotifier(this.repository) : super(false) {
    _loadBiometric();
  }

  Future<void> _loadBiometric() async {
    final result = await repository.getBiometricEnabled();
    result.fold(
      (failure) => null,
      (enabled) => state = enabled,
    );
  }

  Future<void> setBiometric(bool enabled) async {
    state = enabled;
    await repository.setBiometricEnabled(enabled);
  }
}

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>(
  (ref) {
    return LanguageNotifier(ref.watch(settingsRepositoryProvider));
  },
);

class LanguageNotifier extends StateNotifier<String> {
  final SettingsRepository repository;

  LanguageNotifier(this.repository) : super('en') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final result = await repository.getLanguage();
    result.fold(
      (failure) => null,
      (language) => state = language,
    );
  }

  Future<void> setLanguage(String language) async {
    state = language;
    await repository.setLanguage(language);
  }
}