import '../entities/currency_rate.dart';

class ConvertCurrency {
  double call({
    required CurrencyRate rates,
    required String from,
    required String to,
    required double amount,
  }) {
    return rates.convert(from, to, amount);
  }
  
  Map<String, double> convertToMultiple({
    required CurrencyRate rates,
    required String from,
    required List<String> toCurrencies,
    required double amount,
  }) {
    final Map<String, double> results = {};
    
    for (final to in toCurrencies) {
      results[to] = rates.convert(from, to, amount);
    }
    
    return results;
  }
}