import '../../domain/entities/conversion_history.dart';

class ConversionHistoryModel extends ConversionHistory {
  const ConversionHistoryModel({
    required super.id,
    required super.fromCurrency,
    required super.toCurrency,
    required super.fromAmount,
    required super.toAmount,
    required super.rate,
    required super.timestamp,
  });

  factory ConversionHistoryModel.fromJson(Map<String, dynamic> json) {
    return ConversionHistoryModel(
      id: json['id'] as String,
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
      fromAmount: (json['fromAmount'] as num).toDouble(),
      toAmount: (json['toAmount'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'fromAmount': fromAmount,
      'toAmount': toAmount,
      'rate': rate,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ConversionHistoryModel.fromEntity(ConversionHistory entity) {
    return ConversionHistoryModel(
      id: entity.id,
      fromCurrency: entity.fromCurrency,
      toCurrency: entity.toCurrency,
      fromAmount: entity.fromAmount,
      toAmount: entity.toAmount,
      rate: entity.rate,
      timestamp: entity.timestamp,
    );
  }
}