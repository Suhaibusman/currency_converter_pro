import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/rate_chart.dart';
import '../widgets/currency_selector.dart';
import '../../domain/usecases/get_historical_data.dart';

class HistoricalScreen extends ConsumerStatefulWidget {
  const HistoricalScreen({super.key});

  @override
  ConsumerState<HistoricalScreen> createState() => _HistoricalScreenState();
}

class _HistoricalScreenState extends ConsumerState<HistoricalScreen> {
  String _selectedCurrency = 'EUR';
  String? _compareCurrency;
  int _selectedDays = 7;

  final List<int> _dayOptions = [7, 30, 90, 365];

  void _showCurrencySelector(bool isCompare) async {
    final recentSearches = await ref.read(recentSearchesProvider.future);
    
    if (!context.mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencySelector(
        selectedCurrency: isCompare ? (_compareCurrency ?? 'GBP') : _selectedCurrency,
        onCurrencySelected: (currency) {
          setState(() {
            if (isCompare) {
              _compareCurrency = currency;
            } else {
              _selectedCurrency = currency;
            }
          });
          ref.read(currencyRepositoryProvider).addRecentSearch(currency);
        },
        recentSearches: recentSearches,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historicalUseCase = ref.watch(getHistoricalDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Rates'),
        actions: [
          IconButton(
            icon: Icon(
              _compareCurrency != null ? Icons.compare : Icons.compare_outlined,
            ),
            onPressed: () {
              setState(() {
                if (_compareCurrency != null) {
                  _compareCurrency = null;
                } else {
                  _showCurrencySelector(true);
                }
              });
            },
            tooltip: 'Compare currencies',
          ),
        ],
      ),
      body: Column(
        children: [
          // Currency Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCurrencySelector(false),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedCurrency,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                if (_compareCurrency != null) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.compare_arrows),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showCurrencySelector(true),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _compareCurrency!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              ],
            ),
          ),

          // Time Period Selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dayOptions.length,
              itemBuilder: (context, index) {
                final days = _dayOptions[index];
                final isSelected = days == _selectedDays;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      days == 365 ? '1Y' : '${days}D',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDays = days;
                        });
                      }
                    },
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).cardColor,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Chart and Analysis
          Expanded(
            child: FutureBuilder(
              future: Future.wait([
                historicalUseCase.getData(_selectedCurrency, _selectedDays).then(
                      (result) => result.fold(
                        (failure) => throw Exception(failure.message),
                        (data) => data,
                      ),
                    ),
                if (_compareCurrency != null)
                  historicalUseCase.getData(_compareCurrency!, _selectedDays).then(
                        (result) => result.fold(
                          (failure) => throw Exception(failure.message),
                          (data) => data,
                        ),
                      ),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(message: 'Loading historical data...');
                }

                if (snapshot.hasError) {
                  return ErrorWidget(
                    message: snapshot.error.toString(),
                    onRetry: () {
                      setState(() {});
                    },
                  );
                }

                final data = snapshot.data as List<Map<String, double>>;
                final primaryData = data[0];
                
                if (primaryData.isEmpty) {
                  return const Center(
                    child: Text('No historical data available yet.\nData will be collected over time.'),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Primary Chart
                      SizedBox(
                        height: 250,
                        child: RateChart(
                          historicalData: primaryData,
                          currency: _selectedCurrency,
                          lineColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      // Compare Chart
                      if (_compareCurrency != null && data.length > 1) ...[
                        const Divider(),
                        SizedBox(
                          height: 250,
                          child: RateChart(
                            historicalData: data[1],
                            currency: _compareCurrency!,
                            lineColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],

                      // Analysis
                      _buildAnalysis(primaryData, _selectedCurrency),
                      if (_compareCurrency != null && data.length > 1)
                        _buildAnalysis(data[1], _compareCurrency!),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysis(Map<String, double> data, String currency) {
    if (data.isEmpty) return const SizedBox.shrink();

    final values = data.values.toList();
    final high = values.reduce((a, b) => a > b ? a : b);
    final low = values.reduce((a, b) => a < b ? a : b);
    final current = values.last;
    final first = values.first;
    final change = ((current - first) / first) * 100;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$currency Analysis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'High',
                  high.toStringAsFixed(6),
                  Icons.trending_up,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Low',
                  low.toStringAsFixed(6),
                  Icons.trending_down,
                  Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Current',
                  current.toStringAsFixed(6),
                  Icons.show_chart,
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Change',
                  '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                  change >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  change >= 0 
                      ? Colors.green 
                      : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}