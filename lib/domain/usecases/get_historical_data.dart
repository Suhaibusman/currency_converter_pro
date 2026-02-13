import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/snapshot.dart';
import '../repositories/currency_repository.dart';

class GetHistoricalData {
  final CurrencyRepository repository;

  GetHistoricalData(this.repository);

  Future<Either<Failure, List<Snapshot>>> getSnapshots() async {
    return await repository.getSnapshots();
  }
  
  Future<Either<Failure, Map<String, double>>> getData(
    String currency,
    int days,
  ) async {
    return await repository.getHistoricalData(currency, days);
  }
  
  Future<Either<Failure, void>> saveSnapshot(Snapshot snapshot) async {
    return await repository.saveSnapshot(snapshot);
  }
  
  HistoricalAnalysis analyze(List<Snapshot> snapshots, String currency) {
    if (snapshots.isEmpty) {
      return HistoricalAnalysis.empty();
    }
    
    final rates = snapshots
        .map((s) => s.getRate(currency))
        .where((r) => r != null)
        .cast<double>()
        .toList();
    
    if (rates.isEmpty) {
      return HistoricalAnalysis.empty();
    }
    
    final high = rates.reduce((a, b) => a > b ? a : b);
    final low = rates.reduce((a, b) => a < b ? a : b);
    final average = rates.reduce((a, b) => a + b) / rates.length;
    final current = rates.last;
    final previous = rates.first;
    final change = ((current - previous) / previous) * 100;
    
    // Calculate volatility
    final variance = rates
        .map((r) => (r - average) * (r - average))
        .reduce((a, b) => a + b) / rates.length;
    final volatility = variance > 0 ? (variance.abs() / average) * 100 : 0.0;
    
    return HistoricalAnalysis(
      high: high,
      low: low,
      average: average,
      current: current,
      change: change,
      volatility: volatility,
    );
  }
}

class HistoricalAnalysis {
  final double high;
  final double low;
  final double average;
  final double current;
  final double change;
  final double volatility;

  HistoricalAnalysis({
    required this.high,
    required this.low,
    required this.average,
    required this.current,
    required this.change,
    required this.volatility,
  });
  
  factory HistoricalAnalysis.empty() {
    return HistoricalAnalysis(
      high: 0,
      low: 0,
      average: 0,
      current: 0,
      change: 0,
      volatility: 0,
    );
  }
  
  bool get isHighVolatility => volatility > 2.0;
  bool get isIncreasing => change > 0;
  bool get isDecreasing => change < 0;
}