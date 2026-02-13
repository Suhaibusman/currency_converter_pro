import 'package:equatable/equatable.dart';

class Alert extends Equatable {
  final String id;
  final String baseCurrency;
  final String targetCurrency;
  final String type; // 'above', 'below', 'percentage_change'
  final double targetRate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? triggeredAt;

  const Alert({
    required this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.type,
    required this.targetRate,
    required this.isActive,
    required this.createdAt,
    this.triggeredAt,
  });

  @override
  List<Object?> get props => [
        id,
        baseCurrency,
        targetCurrency,
        type,
        targetRate,
        isActive,
        createdAt,
        triggeredAt,
      ];

  Alert copyWith({
    String? id,
    String? baseCurrency,
    String? targetCurrency,
    String? type,
    double? targetRate,
    bool? isActive,
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
      createdAt: createdAt ?? this.createdAt,
      triggeredAt: triggeredAt ?? this.triggeredAt,
    );
  }

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

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
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

  String get displayText {
    switch (type) {
      case 'above':
        return '$targetCurrency above $targetRate $baseCurrency';
      case 'below':
        return '$targetCurrency below $targetRate $baseCurrency';
      case 'percentage_change':
        return '$targetCurrency changes by ${targetRate}%';
      default:
        return 'Unknown alert type';
    }
  }
}