import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';
import '../widgets/common_widgets.dart';
import '../../core/constants/app_constants.dart';

class HeatmapScreen extends ConsumerStatefulWidget {
  const HeatmapScreen({super.key});

  @override
  ConsumerState<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends ConsumerState<HeatmapScreen> {
  final List<String> _displayCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'HKD',
    'NZD',
    'SEK',
    'KRW',
    'SGD',
    'NOK',
    'MXN',
    'INR',
  ];

  @override
  Widget build(BuildContext context) {
    final ratesAsync = ref.watch(currencyRatesProvider);
    final snapshotsAsync = ref.watch(historicalSnapshotsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Heatmap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Heatmap Legend'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLegendItem(context, Colors.green, 'Strong gain'),
                      _buildLegendItem(
                          context, Colors.lightGreen, 'Moderate gain'),
                      _buildLegendItem(context, Colors.grey, 'Neutral'),
                      _buildLegendItem(context, Colors.orange, 'Moderate loss'),
                      _buildLegendItem(context, Colors.red, 'Strong loss'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ratesAsync.when(
        data: (rates) {
          return snapshotsAsync.when(
            data: (snapshots) {
              if (snapshots.isEmpty) {
                return const Center(
                  child: Text(
                    'Heatmap will be available once\nhistorical data is collected',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(currencyRatesProvider);
                  ref.invalidate(historicalSnapshotsProvider);
                },
                child: _buildHeatmap(rates.rates, snapshots),
              );
            },
            loading: () => const LoadingWidget(message: 'Loading heatmap...'),
            error: (error, stack) => CustomErrorWidget(
              message: error.toString(),
              onRetry: () {
                ref.invalidate(historicalSnapshotsProvider);
              },
            ),
          );
        },
        loading: () => const LoadingWidget(message: 'Loading rates...'),
        error: (error, stack) => CustomErrorWidget(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(currencyRatesProvider);
          },
        ),
      ),
    );
  }

  Widget _buildHeatmap(Map<String, double> currentRates, List snapshots) {
    // Calculate 24h changes
    final yesterday = snapshots.isNotEmpty ? snapshots.last : null;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '24-Hour Performance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _displayCurrencies.length,
            itemBuilder: (context, index) {
              final currency = _displayCurrencies[index];
              final currentRate = currentRates[currency] ?? 1.0;

              double changePercent = 0.0;
              if (yesterday != null) {
                final previousRate = yesterday.getRate(currency) ?? currentRate;
                changePercent =
                    ((currentRate - previousRate) / previousRate) * 100;
              }

              return _buildHeatmapCell(currency, changePercent);
            },
          ),
          const SizedBox(height: 16),
          _buildCurrencyRanking(currentRates, snapshots),
        ],
      ),
    );
  }

  Widget _buildHeatmapCell(String currency, double changePercent) {
    Color cellColor;
    if (changePercent > 2) {
      cellColor = Colors.green;
    } else if (changePercent > 0.5) {
      cellColor = Colors.lightGreen;
    } else if (changePercent > -0.5) {
      cellColor = Colors.grey;
    } else if (changePercent > -2) {
      cellColor = Colors.orange;
    } else {
      cellColor = Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currency,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyRanking(
      Map<String, double> currentRates, List snapshots) {
    if (snapshots.isEmpty) return const SizedBox.shrink();

    final yesterday = snapshots.last;
    final List<MapEntry<String, double>> changes = [];

    for (final currency in _displayCurrencies) {
      final currentRate = currentRates[currency] ?? 1.0;
      final previousRate = yesterday.getRate(currency) ?? currentRate;
      final changePercent = ((currentRate - previousRate) / previousRate) * 100;
      changes.add(MapEntry(currency, changePercent));
    }

    changes.sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Currency Strength Ranking',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: changes.length,
          itemBuilder: (context, index) {
            final entry = changes[index];
            final isGainer = entry.value > 0;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isGainer ? Colors.green : Colors.red,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                AppConstants.currencyNames[entry.key] ?? entry.key,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isGainer ? Icons.trending_up : Icons.trending_down,
                    color: isGainer ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.value >= 0 ? '+' : ''}${entry.value.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isGainer ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}
