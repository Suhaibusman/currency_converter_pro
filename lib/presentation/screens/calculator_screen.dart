import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../providers/currency_provider.dart';
import '../widgets/currency_selector.dart';
import '../theme/app_theme.dart';
import '../../core/constants/theme_constants.dart';
import '../providers/theme_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  void _showCurrencySelector(
    BuildContext context,
    bool isFrom,
  ) async {
    final recentSearches = await ref.read(recentSearchesProvider.future);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencySelector(
        selectedCurrency: isFrom
            ? ref.read(calculatorProvider).fromCurrency
            : ref.read(calculatorProvider).toCurrency,
        onCurrencySelected: (currency) {
          if (isFrom) {
            ref.read(calculatorProvider.notifier).setFromCurrency(currency);
          } else {
            ref.read(calculatorProvider.notifier).setToCurrency(currency);
          }
          ref.read(currencyRepositoryProvider).addRecentSearch(currency);
        },
        recentSearches: recentSearches,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calculatorState = ref.watch(calculatorProvider);
    final ratesAsync = ref.watch(currencyRatesProvider);
    final themeMode = ref.watch(themeModeProvider);

    ThemeColors colors;
    if (themeMode == AppThemeMode.systemSync) {
      final brightness = MediaQuery.of(context).platformBrightness;
      colors = ThemeConstants.getSystemTheme(brightness);
    } else {
      colors = ThemeConstants.themes[themeMode] ??
          ThemeConstants.themes[AppThemeMode.midnightLuxe]!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareScreenshot(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Currency Selectors
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCurrencySelector(context, true),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppTheme.glassmorphism(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            calculatorState.fromCurrency,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: () {
                    ref.read(calculatorProvider.notifier).swapCurrencies();
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCurrencySelector(context, false),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppTheme.glassmorphism(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            calculatorState.toCurrency,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: AppTheme.glassmorphism(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      calculatorState.expression.isEmpty
                          ? '0'
                          : calculatorState.expression,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      calculatorState.display,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.right,
                    ),
                    if (calculatorState.result != null)
                      ratesAsync.when(
                        data: (rates) {
                          final converted = rates.convert(
                            calculatorState.fromCurrency,
                            calculatorState.toCurrency,
                            calculatorState.result!,
                          );
                          return Text(
                            '≈ ${converted.toStringAsFixed(4)} ${calculatorState.toCurrency}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: colors.accent,
                                ),
                            textAlign: TextAlign.right,
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Calculator Buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildButtonRow(context, ref, ['7', '8', '9', '÷'], colors),
                  _buildButtonRow(context, ref, ['4', '5', '6', '×'], colors),
                  _buildButtonRow(context, ref, ['1', '2', '3', '-'], colors),
                  _buildButtonRow(context, ref, ['C', '0', '.', '+'], colors),
                  _buildButtonRow(context, ref, ['⌫', '%', '=', '='], colors),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(
    BuildContext context,
    WidgetRef ref,
    List<String> buttons,
    ThemeColors colors,
  ) {
    return Expanded(
      child: Row(
        children: buttons.map((button) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: _buildButton(context, ref, button, colors),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    WidgetRef ref,
    String label,
    ThemeColors colors,
  ) {
    final isOperator = ['+', '-', '×', '÷', '%'].contains(label);
    final isSpecial = ['C', '⌫', '='].contains(label);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSpecial
            ? colors.error
            : isOperator
                ? colors.primary
                : colors.surface,
        foregroundColor: colors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
      ),
      onPressed: () => _handleButtonPress(ref, label),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _handleButtonPress(WidgetRef ref, String label) {
    final notifier = ref.read(calculatorProvider.notifier);

    switch (label) {
      case 'C':
        notifier.clear();
        break;
      case '⌫':
        notifier.backspace();
        break;
      case '=':
        notifier.calculate();
        break;
      case '+':
      case '-':
      case '×':
      case '÷':
      case '%':
        final operator = label == '×'
            ? '*'
            : label == '÷'
                ? '/'
                : label;
        notifier.appendOperator(operator);
        break;
      default:
        notifier.appendNumber(label);
        break;
    }
  }

  Future<void> _shareScreenshot(BuildContext context) async {
    try {
      final image = await screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/calculator_result.png');
      await file.writeAsBytes(image);

      if (context.mounted) {
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Check out this conversion!',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
  }
}
