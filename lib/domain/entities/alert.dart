import 'package:equatable/equatable.dart';

enum AlertType {
  above,
  below,
  percentageChange,
}

class Alert extends Equatable {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final AlertType type;
  final double threshold;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime? lastTriggered;

  const Alert({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.type,
    required this.threshold,
    required this.isEnabled,
    required this.createdAt,
    this.lastTriggered,
  });

  @override
  List<Object?> get props => [
        id,
        fromCurrency,
        toCurrency,
        type,
        threshold,
        isEnabled,
        createdAt,
        lastTriggered,
      ];

  Alert copyWith({
    String? id,
    String? fromCurrency,
    String? toCurrency,
    AlertType? type,
    double? threshold,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? lastTriggered,
  }) {
    return Alert(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      type: type ?? this.type,
      threshold: threshold ?? this.threshold,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastTriggered: lastTriggered ?? this.lastTriggered,
    );
  }
  
  String get description {
    switch (type) {
      case AlertType.above:
        return '$fromCurrency/$toCurrency above ${threshold.toStringAsFixed(4)}';
      case AlertType.below:
        return '$fromCurrency/$toCurrency below ${threshold.toStringAsFixed(4)}';
      case AlertType.percentageChange:
        return '$fromCurrency/$toCurrency changes by ${threshold.toStringAsFixed(2)}%';
    }
  }
}