import '../../domain/entities/alert.dart';

class AlertModel extends Alert {
  const AlertModel({
    required super.id,
    required super.fromCurrency,
    required super.toCurrency,
    required super.type,
    required super.threshold,
    required super.isEnabled,
    required super.createdAt,
    super.lastTriggered,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      fromCurrency: json['from_currency'] as String,
      toCurrency: json['to_currency'] as String,
      type: AlertType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AlertType.above,
      ),
      threshold: (json['threshold'] as num).toDouble(),
      isEnabled: json['is_enabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastTriggered: json['last_triggered'] != null
          ? DateTime.parse(json['last_triggered'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'type': type.name,
      'threshold': threshold,
      'is_enabled': isEnabled,
      'created_at': createdAt.toIso8601String(),
      'last_triggered': lastTriggered?.toIso8601String(),
    };
  }
  
  factory AlertModel.fromEntity(Alert entity) {
    return AlertModel(
      id: entity.id,
      fromCurrency: entity.fromCurrency,
      toCurrency: entity.toCurrency,
      type: entity.type,
      threshold: entity.threshold,
      isEnabled: entity.isEnabled,
      createdAt: entity.createdAt,
      lastTriggered: entity.lastTriggered,
    );
  }
}