import 'package:equatable/equatable.dart';

enum AlertType {
  above,
  below,
  change,
  percentageChange;

  String get displayName {
    switch (this) {
      case AlertType.above:
        return 'Above';
      case AlertType.below:
        return 'Below';
      case AlertType.change:
        return 'Change';
      case AlertType.percentageChange:
        return 'Percentage Change';
    }
  }
}

class Alert {
  final String id;
  final String baseCurrency;
  final String targetCurrency;
  final AlertType type;
  final double targetRate;
  final bool isActive;
  final String? description;
  final DateTime createdAt;
  final DateTime? triggeredAt;

  const Alert({
    required this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.type,
    required this.targetRate,
    required this.isActive,
    this.description,
    required this.createdAt,
    this.triggeredAt,
  });

  // Add getters for backward compatibility
  String get fromCurrency => baseCurrency;
  String get toCurrency => targetCurrency;
  double get threshold => targetRate;
  bool get isEnabled => isActive;

  Alert copyWith({
    String? id,
    String? baseCurrency,
    String? targetCurrency,
    AlertType? type,
    double? targetRate,
    bool? isActive,
    String? description,
    DateTime? createdAt,
    DateTime? triggeredAt,
  }) {
    return Alert(
      id: id ?? this.id,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      type: type ?? this.type,
      targetRate: targetRate ?? this.targetRate,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      triggeredAt: triggeredAt ?? this.triggeredAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'type': type.name,
      'targetRate': targetRate,
      'isActive': isActive,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'triggeredAt': triggeredAt?.toIso8601String(),
    };
  }

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      baseCurrency: json['baseCurrency'],
      targetCurrency: json['targetCurrency'],
      type: AlertType.values.firstWhere((e) => e.name == json['type']),
      targetRate: json['targetRate'],
      isActive: json['isActive'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      triggeredAt: json['triggeredAt'] != null
          ? DateTime.parse(json['triggeredAt'])
          : null,
    );
  }
}
