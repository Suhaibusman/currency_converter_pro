import 'package:equatable/equatable.dart';

class CurrencyRate extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final int timestamp;

  const CurrencyRate({
    required this.baseCurrency,
    required this.rates,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [baseCurrency, rates, timestamp];

  CurrencyRate copyWith({
    String? baseCurrency,
    Map<String, double>? rates,
    int? timestamp,
  }) {
    return CurrencyRate(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      rates: rates ?? this.rates,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  double? getRate(String currency) {
    return rates[currency];
  }

  double convert(String from, String to, double amount) {
    if (from == to) return amount;
    
    final fromRate = rates[from];
    final toRate = rates[to];
    
    if (fromRate == null || toRate == null) {
      throw Exception('Currency not found');
    }
    
    // Convert to base currency first, then to target
    final baseAmount = amount / fromRate;
    return baseAmount * toRate;
  }

  Map<String, double> getAllRatesFrom(String currency) {
    final result = <String, double>{};
    final fromRate = rates[currency];
    
    if (fromRate == null) return result;
    
    for (final entry in rates.entries) {
      if (entry.key != currency) {
        result[entry.key] = entry.value / fromRate;
      }
    }
    
    return result;
  }
}