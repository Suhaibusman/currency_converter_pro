import '../../domain/entities/snapshot.dart';

class SnapshotModel extends Snapshot {
  const SnapshotModel({
    required super.date,
    required super.baseCurrency,
    required super.rates,
  });

  factory SnapshotModel.fromJson(Map<String, dynamic> json) {
    final rates = <String, double>{};
    
    if (json['rates'] != null) {
      final ratesJson = json['rates'] as Map<String, dynamic>;
      ratesJson.forEach((key, value) {
        rates[key] = (value as num).toDouble();
      });
    }
    
    return SnapshotModel(
      date: DateTime.parse(json['date'] as String),
      baseCurrency: json['base_currency'] as String,
      rates: rates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'base_currency': baseCurrency,
      'rates': rates,
    };
  }
  
  factory SnapshotModel.fromEntity(Snapshot entity) {
    return SnapshotModel(
      date: entity.date,
      baseCurrency: entity.baseCurrency,
      rates: entity.rates,
    );
  }
}