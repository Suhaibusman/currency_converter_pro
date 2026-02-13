class CalculatorUtils {
  static double calculate(String expression) {
    try {
      expression = expression.replaceAll(',', '');
      return _evaluateExpression(expression);
    } catch (e) {
      return 0.0;
    }
  }
  
  static double _evaluateExpression(String expression) {
    expression = expression.replaceAll(' ', '');
    
    // Handle percentages
    if (expression.contains('%')) {
      return _handlePercentage(expression);
    }
    
    // Parse and calculate
    final tokens = _tokenize(expression);
    return _evaluate(tokens);
  }
  
  static double _handlePercentage(String expression) {
    final parts = expression.split('%');
    if (parts.length == 2) {
      final base = double.tryParse(parts[0]) ?? 0;
      final percent = double.tryParse(parts[1]) ?? 0;
      return base * (percent / 100);
    }
    return 0.0;
  }
  
  static List<String> _tokenize(String expression) {
    final List<String> tokens = [];
    String currentNumber = '';
    
    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];
      
      if (_isDigitOrDot(char)) {
        currentNumber += char;
      } else if (_isOperator(char)) {
        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber);
          currentNumber = '';
        }
        tokens.add(char);
      }
    }
    
    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber);
    }
    
    return tokens;
  }
  
  static double _evaluate(List<String> tokens) {
    if (tokens.isEmpty) return 0.0;
    
    // Handle multiplication and division first
    for (int i = 1; i < tokens.length; i += 2) {
      if (i < tokens.length && (tokens[i] == '*' || tokens[i] == '/' || tokens[i] == '%')) {
        final left = double.tryParse(tokens[i - 1]) ?? 0;
        final right = double.tryParse(tokens[i + 1]) ?? 0;
        double result;
        
        if (tokens[i] == '*') {
          result = left * right;
        } else if (tokens[i] == '/') {
          result = right != 0 ? left / right : 0;
        } else {
          result = left % right;
        }
        
        tokens[i - 1] = result.toString();
        tokens.removeAt(i);
        tokens.removeAt(i);
        i -= 2;
      }
    }
    
    // Handle addition and subtraction
    double result = double.tryParse(tokens[0]) ?? 0;
    for (int i = 1; i < tokens.length; i += 2) {
      if (i < tokens.length) {
        final operator = tokens[i];
        final operand = double.tryParse(tokens[i + 1]) ?? 0;
        
        if (operator == '+') {
          result += operand;
        } else if (operator == '-') {
          result -= operand;
        }
      }
    }
    
    return result;
  }
  
  static bool _isDigitOrDot(String char) {
    return RegExp(r'[0-9.]').hasMatch(char);
  }
  
  static bool _isOperator(String char) {
    return ['+', '-', '*', '/', '%'].contains(char);
  }
  
  static String formatExpression(String expression) {
    return expression.replaceAll('÷', '/').replaceAll('×', '*');
  }
}