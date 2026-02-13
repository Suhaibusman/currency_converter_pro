import '../../domain/entities/alert.dart';

class AlertModel extends Alert {
  const AlertModel({
    required super.id,
    required super.baseCurrency,
    required super.targetCurrency,
    required super.type,
    required super.targetRate,
    required super.isActive,
    required super.createdAt,
    super.triggeredAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      baseCurrency: json['baseCurrency'] as String,
      targetCurrency: json['targetCurrency'] as String,
      type: json['type'] as String,
      targetRate: (json['targetRate'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      triggeredAt: json['triggeredAt'] != null
          ? DateTime.parse(json['triggeredAt'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'type': type,
      'targetRate': targetRate,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'triggeredAt': triggeredAt?.toIso8601String(),
    };
  }

  factory AlertModel.fromEntity(Alert entity) {
    return AlertModel(
      id: entity.id,
      baseCurrency: entity.baseCurrency,
      targetCurrency: entity.targetCurrency,
      type: entity.type,
      targetRate: entity.targetRate,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      triggeredAt: entity.triggeredAt,
    );
  }
}