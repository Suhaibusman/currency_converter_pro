import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/alert.dart';
import '../entities/conversion_history.dart';
import '../entities/currency_rate.dart';
import '../entities/snapshot.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, CurrencyRate>> getExchangeRates(String baseCurrency);
  
  Future<Either<Failure, void>> saveExchangeRates(CurrencyRate rates);
  
  Future<Either<Failure, CurrencyRate>> getCachedRates();
  
  Future<Either<Failure, void>> saveSnapshot(Snapshot snapshot);
  
  Future<Either<Failure, List<Snapshot>>> getSnapshots({int? limit});
  
  Future<Either<Failure, void>> addConversionHistory(ConversionHistory history);
  
  Future<Either<Failure, List<ConversionHistory>>> getConversionHistory({int? limit});
  
  Future<Either<Failure, void>> clearConversionHistory();
  
  Future<Either<Failure, void>> addAlert(Alert alert);
  
  Future<Either<Failure, List<Alert>>> getAlerts();
  
  Future<Either<Failure, void>> updateAlert(Alert alert);
  
  Future<Either<Failure, void>> deleteAlert(String alertId);
  
  Future<Either<Failure, void>> addFavoritePair(String pair);
  
  Future<Either<Failure, List<String>>> getFavoritePairs();
  
  Future<Either<Failure, void>> removeFavoritePair(String pair);
  
  Future<Either<Failure, void>> addRecentSearch(String search);
  
  Future<Either<Failure, List<String>>> getRecentSearches();
  
  Future<Either<Failure, String>> getApiKey();
}