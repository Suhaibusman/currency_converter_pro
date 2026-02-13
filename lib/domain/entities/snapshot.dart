import 'package:equatable/equatable.dart';

class Snapshot extends Equatable {
  final DateTime date;
  final String baseCurrency;
  final Map<String, double> rates;

  const Snapshot({
    required this.date,
    required this.baseCurrency,
    required this.rates,
  });

  @override
  List<Object?> get props => [date, baseCurrency, rates];
  
  double? getRate(String currency) {
    return rates[currency];
  }
}