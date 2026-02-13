import 'package:equatable/equatable.dart';

class Snapshot extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime date;

  const Snapshot({
    required this.baseCurrency,
    required this.rates,
    required this.date,
  });

  @override
  List<Object?> get props => [baseCurrency, rates, date];

  Map<String, dynamic> toJson() {
    return {
      'baseCurrency': baseCurrency,
      'rates': rates,
      'date': date.toIso8601String(),
    };
  }

  factory Snapshot.fromJson(Map<String, dynamic> json) {
    return Snapshot(
      baseCurrency: json['baseCurrency'] as String,
      rates: Map<String, double>.from(json['rates'] as Map),
      date: DateTime.parse(json['date'] as String),
    );
  }

  double? getRate(String currency) {
    return rates[currency];
  }

  double getRateChange(String currency, Snapshot previousSnapshot) {
    final currentRate = rates[currency];
    final previousRate = previousSnapshot.rates[currency];
    
    if (currentRate == null || previousRate == null) return 0.0;
    
    return ((currentRate - previousRate) / previousRate) * 100;
  }
}