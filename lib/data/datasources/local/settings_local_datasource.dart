import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<String> getBaseCurrency();
  Future<void> setBaseCurrency(String currency);
  
  Future<String> getHomeCurrency();
  Future<void> setHomeCurrency(String currency);
  
  Future<List<String>> getSelectedCurrencies();
  Future<void> setSelectedCurrencies(List<String> currencies);
  
  Future<String> getTheme();
  Future<void> setTheme(String theme);
  
  Future<int> getCustomColor();
  Future<void> setCustomColor(int color);
  
  Future<double> getFontSize();
  Future<void> setFontSize(double size);
  
  Future<int> getDecimalPrecision();
  Future<void> setDecimalPrecision(int precision);
  
  Future<String> getRoundingMode();
  Future<void> setRoundingMode(String mode);
  
  Future<bool> getBiometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);
  
  Future<String> getLanguage();
  Future<void> setLanguage(String language);
  
  Future<void> clearAllData();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<String> getBaseCurrency() async {
    return sharedPreferences.getString(AppConstants.baseCurrencyKey) ?? 
           AppConstants.defaultBaseCurrency;
  }

  @override
  Future<void> setBaseCurrency(String currency) async {
    await sharedPreferences.setString(AppConstants.baseCurrencyKey, currency);
  }

  @override
  Future<String> getHomeCurrency() async {
    return sharedPreferences.getString(AppConstants.homeCurrencyKey) ?? 
           AppConstants.defaultBaseCurrency;
  }

  @override
  Future<void> setHomeCurrency(String currency) async {
    await sharedPreferences.setString(AppConstants.homeCurrencyKey, currency);
  }

  @override
  Future<List<String>> getSelectedCurrencies() async {
    return sharedPreferences.getStringList(AppConstants.selectedCurrenciesKey) ?? 
           ['USD', 'EUR', 'GBP', 'JPY'];
  }

  @override
  Future<void> setSelectedCurrencies(List<String> currencies) async {
    await sharedPreferences.setStringList(
      AppConstants.selectedCurrenciesKey,
      currencies,
    );
  }

  @override
  Future<String> getTheme() async {
    return sharedPreferences.getString(AppConstants.themeKey) ?? 'systemSync';
  }

  @override
  Future<void> setTheme(String theme) async {
    await sharedPreferences.setString(AppConstants.themeKey, theme);
  }

  @override
  Future<int> getCustomColor() async {
    return sharedPreferences.getInt(AppConstants.customColorKey) ?? 0xFF6C63FF;
  }

  @override
  Future<void> setCustomColor(int color) async {
    await sharedPreferences.setInt(AppConstants.customColorKey, color);
  }

  @override
  Future<double> getFontSize() async {
    return sharedPreferences.getDouble(AppConstants.fontSizeKey) ?? 14.0;
  }

  @override
  Future<void> setFontSize(double size) async {
    await sharedPreferences.setDouble(AppConstants.fontSizeKey, size);
  }

  @override
  Future<int> getDecimalPrecision() async {
    return sharedPreferences.getInt(AppConstants.decimalPrecisionKey) ?? 
           AppConstants.defaultDecimalPrecision;
  }

  @override
  Future<void> setDecimalPrecision(int precision) async {
    await sharedPreferences.setInt(AppConstants.decimalPrecisionKey, precision);
  }

  @override
  Future<String> getRoundingMode() async {
    return sharedPreferences.getString(AppConstants.roundingModeKey) ?? 'halfUp';
  }

  @override
  Future<void> setRoundingMode(String mode) async {
    await sharedPreferences.setString(AppConstants.roundingModeKey, mode);
  }

  @override
  Future<bool> getBiometricEnabled() async {
    return sharedPreferences.getBool(AppConstants.biometricEnabledKey) ?? false;
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await sharedPreferences.setBool(AppConstants.biometricEnabledKey, enabled);
  }

  @override
  Future<String> getLanguage() async {
    return sharedPreferences.getString(AppConstants.languageKey) ?? 'en';
  }

  @override
  Future<void> setLanguage(String language) async {
    await sharedPreferences.setString(AppConstants.languageKey, language);
  }

  @override
  Future<void> clearAllData() async {
    await sharedPreferences.clear();
  }
}