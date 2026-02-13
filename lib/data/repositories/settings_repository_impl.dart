import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, String>> getBaseCurrency() async {
    try {
      final currency = await localDataSource.getBaseCurrency();
      return Right(currency);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setBaseCurrency(String currency) async {
    try {
      await localDataSource.setBaseCurrency(currency);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getHomeCurrency() async {
    try {
      final currency = await localDataSource.getHomeCurrency();
      return Right(currency);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setHomeCurrency(String currency) async {
    try {
      await localDataSource.setHomeCurrency(currency);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSelectedCurrencies() async {
    try {
      final currencies = await localDataSource.getSelectedCurrencies();
      return Right(currencies);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setSelectedCurrencies(
    List<String> currencies,
  ) async {
    try {
      await localDataSource.setSelectedCurrencies(currencies);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getTheme() async {
    try {
      final theme = await localDataSource.getTheme();
      return Right(theme);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setTheme(String theme) async {
    try {
      await localDataSource.setTheme(theme);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getCustomColor() async {
    try {
      final color = await localDataSource.getCustomColor();
      return Right(color);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setCustomColor(int color) async {
    try {
      await localDataSource.setCustomColor(color);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, double>> getFontSize() async {
    try {
      final size = await localDataSource.getFontSize();
      return Right(size);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setFontSize(double size) async {
    try {
      await localDataSource.setFontSize(size);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getDecimalPrecision() async {
    try {
      final precision = await localDataSource.getDecimalPrecision();
      return Right(precision);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setDecimalPrecision(int precision) async {
    try {
      await localDataSource.setDecimalPrecision(precision);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getRoundingMode() async {
    try {
      final mode = await localDataSource.getRoundingMode();
      return Right(mode);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setRoundingMode(String mode) async {
    try {
      await localDataSource.setRoundingMode(mode);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> getBiometricEnabled() async {
    try {
      final enabled = await localDataSource.getBiometricEnabled();
      return Right(enabled);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setBiometricEnabled(bool enabled) async {
    try {
      await localDataSource.setBiometricEnabled(enabled);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getLanguage() async {
    try {
      final language = await localDataSource.getLanguage();
      return Right(language);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setLanguage(String language) async {
    try {
      await localDataSource.setLanguage(language);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllData() async {
    try {
      await localDataSource.clearAllData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}