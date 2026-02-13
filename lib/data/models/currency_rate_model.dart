import '../../domain/entities/currency_rate.dart';

class CurrencyRateModel extends CurrencyRate {
  const CurrencyRateModel({
    required super.baseCurrency,
    required super.rates,
    required super.timestamp,
    required super.nextUpdateTimestamp,
  });

  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) {
    final rates = <String, double>{};
    
    if (json['conversion_rates'] != null) {
      final conversionRates = json['conversion_rates'] as Map<String, dynamic>;
      conversionRates.forEach((key, value) {
        rates[key] = (value as num).toDouble();
      });
    }
    
    return CurrencyRateModel(
      baseCurrency: json['base_code'] as String? ?? 'USD',
      rates: rates,
      timestamp: json['time_last_update_unix'] as int? ?? 0,
      nextUpdateTimestamp: json['time_next_update_unix'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCurrency,
      'conversion_rates': rates,
      'time_last_update_unix': timestamp,
      'time_next_update_unix': nextUpdateTimestamp,
    };
  }
  
  factory CurrencyRateModel.fromEntity(CurrencyRate entity) {
    return CurrencyRateModel(
      baseCurrency: entity.baseCurrency,
      rates: entity.rates,
      timestamp: entity.timestamp,
      nextUpdateTimestamp: entity.nextUpdateTimestamp,
    );
  }
}