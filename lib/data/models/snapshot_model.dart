import '../../domain/entities/snapshot.dart';

class SnapshotModel extends Snapshot {
  const SnapshotModel({
    required super.baseCurrency,
    required super.rates,
    required super.date,
  });

  factory SnapshotModel.fromJson(Map<String, dynamic> json) {
    return SnapshotModel(
      baseCurrency: json['baseCurrency'] as String,
      rates: Map<String, double>.from(json['rates'] as Map),
      date: DateTime.parse(json['date'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'baseCurrency': baseCurrency,
      'rates': rates,
      'date': date.toIso8601String(),
    };
  }

  factory SnapshotModel.fromEntity(Snapshot entity) {
    return SnapshotModel(
      baseCurrency: entity.baseCurrency,
      rates: entity.rates,
      date: entity.date,
    );
  }
}