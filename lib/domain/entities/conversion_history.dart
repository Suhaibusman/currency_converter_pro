import 'package:equatable/equatable.dart';

class ConversionHistory extends Equatable {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final double fromAmount;
  final double toAmount;
  final double rate;
  final DateTime timestamp;

  const ConversionHistory({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.fromAmount,
    required this.toAmount,
    required this.rate,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        fromCurrency,
        toCurrency,
        fromAmount,
        toAmount,
        rate,
        timestamp,
      ];

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

  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      id: json['id'] as String,
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
      fromAmount: (json['fromAmount'] as num).toDouble(),
      toAmount: (json['toAmount'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  String get displayText {
    return '$fromAmount $fromCurrency = $toAmount $toCurrency';
  }
}