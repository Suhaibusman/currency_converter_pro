import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/snapshot.dart';
import '../repositories/currency_repository.dart';

class GetHistoricalData {
  final CurrencyRepository repository;

  GetHistoricalData(this.repository);

  Future<Either<Failure, List<Snapshot>>> call({int? days}) async {
    return await repository.getSnapshots(limit: days);
  }

  Future<Either<Failure, Map<String, dynamic>>> getStatistics({
    required String currency,
    required List<Snapshot> snapshots,
  }) async {
    if (snapshots.isEmpty) {
      return const Left(DataNotFoundFailure('No historical data available'));
    }

    final rates = snapshots
        .map((s) => s.getRate(currency))
        .where((r) => r != null)
        .map((r) => r!)
        .toList();

    if (rates.isEmpty) {
      return const Left(DataNotFoundFailure('No data for currency'));
    }

    final high = rates.reduce((a, b) => a > b ? a : b);
    final low = rates.reduce((a, b) => a < b ? a : b);
    final avg = rates.reduce((a, b) => a + b) / rates.length;
    final current = rates.last;
    final change = ((current - rates.first) / rates.first) * 100;

    return Right({
      'high': high,
      'low': low,
      'average': avg,
      'current': current,
      'change': change,
      'volatility': _calculateVolatility(rates),
    });
  }

  double _calculateVolatility(List<double> rates) {
    if (rates.length < 2) return 0.0;
    
    final avg = rates.reduce((a, b) => a + b) / rates.length;
    final variance = rates
        .map((r) => (r - avg) * (r - avg))
        .reduce((a, b) => a + b) / rates.length;
    
    return variance;
  }
}