import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class SettingsRepository {
  Future<Either<Failure, String>> getBaseCurrency();
  Future<Either<Failure, void>> setBaseCurrency(String currency);
  
  Future<Either<Failure, String>> getHomeCurrency();
  Future<Either<Failure, void>> setHomeCurrency(String currency);
  
  Future<Either<Failure, List<String>>> getSelectedCurrencies();
  Future<Either<Failure, void>> setSelectedCurrencies(List<String> currencies);
  
  Future<Either<Failure, String>> getTheme();
  Future<Either<Failure, void>> setTheme(String theme);
  
  Future<Either<Failure, int>> getCustomColor();
  Future<Either<Failure, void>> setCustomColor(int color);
  
  Future<Either<Failure, double>> getFontSize();
  Future<Either<Failure, void>> setFontSize(double size);
  
  Future<Either<Failure, int>> getDecimalPrecision();
  Future<Either<Failure, void>> setDecimalPrecision(int precision);
  
  Future<Either<Failure, String>> getRoundingMode();
  Future<Either<Failure, void>> setRoundingMode(String mode);
  
  Future<Either<Failure, bool>> getBiometricEnabled();
  Future<Either<Failure, void>> setBiometricEnabled(bool enabled);
  
  Future<Either<Failure, String>> getLanguage();
  Future<Either<Failure, void>> setLanguage(String language);
  
  Future<Either<Failure, void>> clearAllData();
}