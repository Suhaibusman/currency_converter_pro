import 'package:equatable/equatable.dart';

class CurrencyRate extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final int timestamp;
  final int nextUpdateTimestamp;

  const CurrencyRate({
    required this.baseCurrency,
    required this.rates,
    required this.timestamp,
    required this.nextUpdateTimestamp,
  });

  @override
  List<Object?> get props => [baseCurrency, rates, timestamp, nextUpdateTimestamp];
  
  double? getRate(String currency) {
    return rates[currency];
  }
  
  double convert(String from, String to, double amount) {
    if (from == to) return amount;
    
    final fromRate = from == baseCurrency ? 1.0 : (rates[from] ?? 1.0);
    final toRate = to == baseCurrency ? 1.0 : (rates[to] ?? 1.0);
    
    return amount * (toRate / fromRate);
  }
}