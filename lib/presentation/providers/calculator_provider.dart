import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../core/utils/calculator_utils.dart';

// Calculator State
class CalculatorState {
  final String display;
  final String expression;
  final String fromCurrency;
  final String toCurrency;
  final double? result;

  const CalculatorState({
    this.display = '0',
    this.expression = '',
    this.fromCurrency = 'USD',
    this.toCurrency = 'EUR',
    this.result,
  });

  CalculatorState copyWith({
    String? display,
    String? expression,
    String? fromCurrency,
    String? toCurrency,
    double? result,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      expression: expression ?? this.expression,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      result: result ?? this.result,
    );
  }
}

// Calculator Provider
final calculatorProvider = 
    StateNotifierProvider<CalculatorNotifier, CalculatorState>(
  (ref) => CalculatorNotifier(),
);

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier() : super(const CalculatorState());

  void appendNumber(String number) {
    if (state.display == '0' && number != '.') {
      state = state.copyWith(
        display: number,
        expression: state.expression + number,
      );
    } else if (number == '.' && state.display.contains('.')) {
      return;
    } else {
      state = state.copyWith(
        display: state.display + number,
        expression: state.expression + number,
      );
    }
  }

  void appendOperator(String operator) {
    if (state.expression.isEmpty) return;
    
    state = state.copyWith(
      display: operator,
      expression: state.expression + operator,
    );
  }

  void calculate() {
    if (state.expression.isEmpty) return;
    
    final result = CalculatorUtils.calculate(state.expression);
    
    state = state.copyWith(
      display: result.toString(),
      expression: result.toString(),
      result: result,
    );
  }

  void clear() {
    state = const CalculatorState();
  }

  void backspace() {
    if (state.display.isEmpty || state.display == '0') return;
    
    final newDisplay = state.display.substring(0, state.display.length - 1);
    final newExpression = state.expression.substring(0, state.expression.length - 1);
    
    state = state.copyWith(
      display: newDisplay.isEmpty ? '0' : newDisplay,
      expression: newExpression,
    );
  }

  void setFromCurrency(String currency) {
    state = state.copyWith(fromCurrency: currency);
  }

  void setToCurrency(String currency) {
    state = state.copyWith(toCurrency: currency);
  }

  void swapCurrencies() {
    state = state.copyWith(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
    );
  }
}