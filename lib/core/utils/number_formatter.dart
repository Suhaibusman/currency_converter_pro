import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatCurrency(
    double amount, {
    int decimalPlaces = 4,
    bool largeNumberFormat = false,
    RoundingMode roundingMode = RoundingMode.halfUp,
  }) {
    if (largeNumberFormat && amount.abs() >= 1000000) {
      return _formatLargeNumber(amount, decimalPlaces);
    }
    
    double rounded = _round(amount, decimalPlaces, roundingMode);
    
    final formatter = NumberFormat('#,##0.${'0' * decimalPlaces}', 'en_US');
    return formatter.format(rounded);
  }
  
  static double _round(double value, int places, RoundingMode mode) {
    final multiplier = pow(10, places).toDouble();
    
    switch (mode) {
      case RoundingMode.up:
        return (value * multiplier).ceilToDouble() / multiplier;
      case RoundingMode.down:
        return (value * multiplier).floorToDouble() / multiplier;
      case RoundingMode.halfUp:
      default:
        return (value * multiplier).roundToDouble() / multiplier;
    }
  }
  
  static String _formatLargeNumber(double amount, int decimalPlaces) {
    if (amount.abs() >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(2)}B';
    } else if (amount.abs() >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K';
    }
    return amount.toStringAsFixed(decimalPlaces);
  }
  
  static String formatPercentage(double value, {int decimalPlaces = 2}) {
    return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(decimalPlaces)}%';
  }
  
  static double parseDouble(String value) {
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }
}

enum RoundingMode {
  up,
  down,
  halfUp,
}

int pow(int base, int exponent) {
  int result = 1;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}