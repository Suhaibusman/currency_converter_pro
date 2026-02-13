import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/alert.dart';
import '../../domain/entities/conversion_history.dart';
import '../../domain/entities/currency_rate.dart';
import '../../domain/entities/snapshot.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/local/currency_local_datasource.dart';
import '../datasources/remote/currency_remote_datasource.dart';
import '../models/alert_model.dart';
import '../models/conversion_history_model.dart';
import '../models/currency_rate_model.dart';
import '../models/snapshot_model.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, void>> addAlert(Alert alert) async {
    try {
      final alertModel = AlertModel.fromEntity(alert);
      await localDataSource.saveAlert(alertModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveAlert(Alert alert) async {
    try {
      final alertModel = AlertModel.fromEntity(alert);
      await localDataSource.saveAlert(alertModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveExchangeRates(CurrencyRate rates) async {
    try {
      final model = CurrencyRateModel.fromEntity(rates);
      await localDataSource.cacheRates(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConversionHistory>>> getConversionHistory(
      {int? limit}) async {
    try {
      final history = await localDataSource.getConversionHistory();
      if (limit != null && history.length > limit) {
        return Right(history.take(limit).toList());
      }
      return Right(history);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Snapshot>>> getSnapshots({int? limit}) async {
    try {
      final snapshots = await localDataSource.getSnapshots();
      if (limit != null && snapshots.length > limit) {
        return Right(snapshots.take(limit).toList());
      }
      return Right(snapshots);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CurrencyRate>> getExchangeRates(
    String baseCurrency,
  ) async {
    try {
      // Check if we need to update
      final lastUpdate = await localDataSource.getLastUpdateTimestamp();

      if (!AppDateUtils.shouldUpdate(lastUpdate)) {
        // Use cached data
        final cached = await localDataSource.getCachedRates();
        return Right(cached);
      }

      // Check network
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        // Return cached data if available
        try {
          final cached = await localDataSource.getCachedRates();
          return Right(cached);
        } catch (e) {
          return const Left(NetworkFailure('No internet and no cached data'));
        }
      }

      // Fetch API key
      String apiKey;
      try {
        apiKey = await localDataSource.getApiKey();
      } catch (e) {
        // Fetch from Supabase
        try {
          apiKey = await remoteDataSource.fetchApiKeyFromSupabase();
          await localDataSource.cacheApiKey(apiKey);
        } catch (e) {
          return Left(AuthFailure('Failed to get API key: $e'));
        }
      }

      // Fetch fresh data
      final rates = await remoteDataSource.getExchangeRates(
        baseCurrency,
      );

      // Cache the data
      await localDataSource.cacheRates(rates);
      await localDataSource.setLastUpdateTimestamp(
        AppDateUtils.getCurrentTimestamp(),
      );

      // Save snapshot
      final snapshot = SnapshotModel(
        date: AppDateUtils.getDateOnly(AppDateUtils.now()),
        baseCurrency: rates.baseCurrency,
        rates: rates.rates,
      );
      await localDataSource.saveSnapshot(snapshot);

      return Right(rates);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, CurrencyRate>> getCachedRates() async {
    try {
      final rates = await localDataSource.getCachedRates();
      return Right(rates);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  Future<Either<Failure, void>> cacheRates(CurrencyRate rates) async {
    try {
      final model = CurrencyRateModel.fromEntity(rates);
      await localDataSource.cacheRates(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getApiKey() async {
    try {
      final apiKey = await localDataSource.getApiKey();
      return Right(apiKey);
    } on CacheException {
      try {
        final apiKey = await remoteDataSource.fetchApiKeyFromSupabase();
        await localDataSource.cacheApiKey(apiKey);
        return Right(apiKey);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(AuthFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, void>> cacheApiKey(String apiKey) async {
    try {
      await localDataSource.cacheApiKey(apiKey);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addConversionHistory(
    ConversionHistory history,
  ) async {
    try {
      final model = ConversionHistoryModel.fromEntity(history);
      await localDataSource.addConversionHistory(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearConversionHistory() async {
    try {
      await localDataSource.clearConversionHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveSnapshot(Snapshot snapshot) async {
    try {
      final model = SnapshotModel.fromEntity(snapshot);
      await localDataSource.saveSnapshot(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getHistoricalData(
    String currency,
    int days,
  ) async {
    try {
      final snapshots = await localDataSource.getSnapshots();

      // Sort by date descending
      snapshots.sort((a, b) => b.date.compareTo(a.date));

      // Get requested days
      final end = AppDateUtils.now();
      final start = end.subtract(Duration(days: days - 1));
      final dateRange = AppDateUtils.getDayRange(start, end);
      final Map<String, double> historicalData = {};

      for (final date in dateRange) {
        final snapshot = snapshots.firstWhere(
          (s) => AppDateUtils.getDateOnly(s.date) == date,
          orElse: () => snapshots.first,
        );

        final rate = snapshot.getRate(currency);
        if (rate != null) {
          historicalData[AppDateUtils.formatDate(date)] = rate;
        }
      }

      return Right(historicalData);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Alert>>> getAlerts() async {
    try {
      final alerts = await localDataSource.getAlerts();
      return Right(alerts);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAlert(String alertId) async {
    try {
      await localDataSource.deleteAlert(alertId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateAlert(Alert alert) async {
    try {
      final model = AlertModel.fromEntity(alert);
      await localDataSource.saveAlert(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFavoritePairs() async {
    try {
      final pairs = await localDataSource.getFavoritePairs();
      return Right(pairs);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addFavoritePair(String pair) async {
    try {
      await localDataSource.addFavoritePair(pair);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoritePair(String pair) async {
    try {
      await localDataSource.removeFavoritePair(pair);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSearches() async {
    try {
      final searches = await localDataSource.getRecentSearches();
      return Right(searches);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addRecentSearch(String currency) async {
    try {
      await localDataSource.addRecentSearch(currency);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
