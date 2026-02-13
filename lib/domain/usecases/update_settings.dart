import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/settings_repository.dart';

class UpdateSettings {
  final SettingsRepository repository;

  UpdateSettings(this.repository);

  Future<Either<Failure, void>> setBaseCurrency(String currency) async {
    return await repository.setBaseCurrency(currency);
  }
  
  Future<Either<Failure, void>> setTheme(String theme) async {
    return await repository.setTheme(theme);
  }
  
  Future<Either<Failure, void>> setDecimalPrecision(int precision) async {
    return await repository.setDecimalPrecision(precision);
  }
  
  Future<Either<Failure, void>> setBiometric(bool enabled) async {
    return await repository.setBiometricEnabled(enabled);
  }
}