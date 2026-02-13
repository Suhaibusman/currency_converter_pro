import '../../domain/entities/currency_rate.dart';

class CurrencyRateModel extends CurrencyRate {
  const CurrencyRateModel({
    required super.baseCurrency,
    required super.rates,
    required super.timestamp,
  });

  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRateModel(
      baseCurrency: json['base_code'] as String,
      rates: Map<String, double>.from(
        (json['conversion_rates'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
      timestamp: json['time_last_update_unix'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCurrency,
      'conversion_rates': rates,
      'time_last_update_unix': timestamp,
    };
  }

  factory CurrencyRateModel.fromEntity(CurrencyRate entity) {
    return CurrencyRateModel(
      baseCurrency: entity.baseCurrency,
      rates: entity.rates,
      timestamp: entity.timestamp,
    );
  }
}