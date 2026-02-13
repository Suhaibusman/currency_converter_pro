import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';
import '../widgets/common_widgets.dart';
import '../../domain/usecases/get_historical_data.dart';
import '../../core/constants/app_constants.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotsAsync = ref.watch(historicalSnapshotsProvider);
    final ratesAsync = ref.watch(currencyRatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Insights'),
      ),
      body: ratesAsync.when(
        data: (rates) {
          return snapshotsAsync.when(
            data: (snapshots) {
              if (snapshots.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'Insights will be generated once\nhistorical data is collected over time',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(historicalSnapshotsProvider);
                  ref.invalidate(currencyRatesProvider);
                },
                child: _buildInsights(context, ref, snapshots, rates.rates),
              );
            },
            loading: () => const LoadingWidget(message: 'Generating insights...'),
            error: (error, stack) => ErrorWidget(
              message: error.toString(),
              onRetry: () {
                ref.invalidate(historicalSnapshotsProvider);
              },
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidget(message: error.toString()),
      ),
    );
  }

  Widget _buildInsights(
    BuildContext context,
    WidgetRef ref,
    List snapshots,
    Map<String, double> currentRates,
  ) {
    final insights = _generateInsights(snapshots, currentRates);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: insights.length,
      itemBuilder: (context, index) {
        final insight = insights[index];
        return _buildInsightCard(context, insight);
      },
    );
  }

  List<Insight> _generateInsights(List snapshots, Map<String, double> currentRates) {
    final List<Insight> insights = [];

    if (snapshots.length < 2) return insights;

    // Analyze popular currencies
    for (final currency in ['EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF']) {
      if (!currentRates.containsKey(currency)) continue;

      // 7-day analysis
      if (snapshots.length >= 7) {
        final last7Days = snapshots.sublist(snapshots.length - 7);
        final rates = last7Days
            .map((s) => s.getRate(currency))
            .where((r) => r != null)
            .cast<double>()
            .toList();

        if (rates.length >= 2) {
          final change = ((rates.last - rates.first) / rates.first) * 100;
          
          if (change.abs() > 1.0) {
            insights.add(Insight(
              title: change > 0 ? '$currency Strengthening' : '$currency Weakening',
              description: '$currency has ${change > 0 ? 'increased' : 'decreased'} by ${change.abs().toStringAsFixed(2)}% in the last 7 days',
              icon: change > 0 ? Icons.trending_up : Icons.trending_down,
              color: change > 0 ? Colors.green : Colors.red,
              type: InsightType.trend,
            ));
          }

          // Volatility check
          final avg = rates.reduce((a, b) => a + b) / rates.length;
          final variance = rates
              .map((r) => (r - avg) * (r - avg))
              .reduce((a, b) => a + b) / rates.length;
          final volatility = (variance.abs() / avg) * 100;

          if (volatility > 2.0) {
            insights.add(Insight(
              title: 'High Volatility: $currency',
              description: '$currency is showing high volatility with ${volatility.toStringAsFixed(2)}% variance',
              icon: Icons.warning_amber_rounded,
              color: Colors.orange,
              type: InsightType.volatility,
            ));
          }
        }
      }

      // 30-day high/low
      if (snapshots.length >= 30) {
        final last30Days = snapshots.sublist(snapshots.length - 30);
        final rates = last30Days
            .map((s) => s.getRate(currency))
            .where((r) => r != null)
            .cast<double>()
            .toList();

        if (rates.isNotEmpty) {
          final high = rates.reduce((a, b) => a > b ? a : b);
          final low = rates.reduce((a, b) => a < b ? a : b);
          final current = currentRates[currency]!;

          if ((current - low).abs() < (high - low) * 0.05) {
            insights.add(Insight(
              title: '$currency Near 30-Day Low',
              description: '$currency is trading near its 30-day low of ${low.toStringAsFixed(6)}',
              icon: Icons.south,
              color: Colors.blue,
              type: InsightType.milestone,
            ));
          } else if ((high - current).abs() < (high - low) * 0.05) {
            insights.add(Insight(
              title: '$currency Near 30-Day High',
              description: '$currency is trading near its 30-day high of ${high.toStringAsFixed(6)}',
              icon: Icons.north,
              color: Colors.purple,
              type: InsightType.milestone,
            ));
          }
        }
      }
    }

    // Travel recommendations
    insights.add(Insight(
      title: 'Travel Mode Available',
      description: 'Enable Travel Mode in settings to track currencies for your next trip',
      icon: Icons.flight_takeoff,
      color: Colors.teal,
      type: InsightType.tip,
    ));

    return insights;
  }

  Widget _buildInsightCard(BuildContext context, Insight insight) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: insight.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                insight.icon,
                color: insight.color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insight.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Insight {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final InsightType type;

  Insight({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
  });
}

enum InsightType {
  trend,
  volatility,
  milestone,
  tip,
}