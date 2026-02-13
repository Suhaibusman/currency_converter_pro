import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/currency_rate.dart';
import '../entities/conversion_history.dart';
import '../entities/snapshot.dart';
import '../entities/alert.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, CurrencyRate>> getExchangeRates(String baseCurrency);
  Future<Either<Failure, CurrencyRate>> getCachedRates();
  Future<Either<Failure, void>> cacheRates(CurrencyRate rates);
  Future<Either<Failure, String>> getApiKey();
  Future<Either<Failure, void>> cacheApiKey(String apiKey);
  
  // History
  Future<Either<Failure, List<ConversionHistory>>> getConversionHistory();
  Future<Either<Failure, void>> addConversionHistory(ConversionHistory history);
  Future<Either<Failure, void>> clearConversionHistory();
  
  // Snapshots
  Future<Either<Failure, List<Snapshot>>> getSnapshots();
  Future<Either<Failure, void>> saveSnapshot(Snapshot snapshot);
  Future<Either<Failure, Map<String, double>>> getHistoricalData(
    String currency,
    int days,
  );
  
  // Alerts
  Future<Either<Failure, List<Alert>>> getAlerts();
  Future<Either<Failure, void>> saveAlert(Alert alert);
  Future<Either<Failure, void>> deleteAlert(String alertId);
  Future<Either<Failure, void>> updateAlert(Alert alert);
  
  // Favorites
  Future<Either<Failure, List<String>>> getFavoritePairs();
  Future<Either<Failure, void>> addFavoritePair(String pair);
  Future<Either<Failure, void>> removeFavoritePair(String pair);
  
  // Recent Searches
  Future<Either<Failure, List<String>>> getRecentSearches();
  Future<Either<Failure, void>> addRecentSearch(String currency);
}