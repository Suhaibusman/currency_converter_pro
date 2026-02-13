import 'package:equatable/equatable.dart';

class ConversionHistory extends Equatable {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double result;
  final double rate;
  final DateTime timestamp;

  const ConversionHistory({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.result,
    required this.rate,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        fromCurrency,
        toCurrency,
        amount,
        result,
        rate,
        timestamp,
      ];
}