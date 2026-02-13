import '../../domain/entities/conversion_history.dart';

class ConversionHistoryModel extends ConversionHistory {
  const ConversionHistoryModel({
    required super.id,
    required super.fromCurrency,
    required super.toCurrency,
    required super.amount,
    required super.result,
    required super.rate,
    required super.timestamp,
  });

  factory ConversionHistoryModel.fromJson(Map<String, dynamic> json) {
    return ConversionHistoryModel(
      id: json['id'] as String,
      fromCurrency: json['from_currency'] as String,
      toCurrency: json['to_currency'] as String,
      amount: (json['amount'] as num).toDouble(),
      result: (json['result'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'amount': amount,
      'result': result,
      'rate': rate,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory ConversionHistoryModel.fromEntity(ConversionHistory entity) {
    return ConversionHistoryModel(
      id: entity.id,
      fromCurrency: entity.fromCurrency,
      toCurrency: entity.toCurrency,
      amount: entity.amount,
      result: entity.result,
      rate: entity.rate,
      timestamp: entity.timestamp,
    );
  }
}