import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RateChart extends StatelessWidget {
  final Map<String, double> historicalData;
  final String currency;
  final Color lineColor;

  const RateChart({
    super.key,
    required this.historicalData,
    required this.currency,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    if (historicalData.isEmpty) {
      return const Center(
        child: Text('No historical data available'),
      );
    }

    final spots = _buildSpots();
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final padding = range * 0.1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: range / 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.1),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (spots.length / 5).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= spots.length) return const Text('');
                  final dates = historicalData.keys.toList();
                  final date = dates[value.toInt()];
                  final parts = date.split('-');
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${parts[1]}/${parts[2]}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: range / 5,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(4),
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          minX: 0,
          maxX: spots.length.toDouble() - 1,
          minY: minY - padding,
          maxY: maxY + padding,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: lineColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: spots.length <= 30,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: lineColor,
                    strokeWidth: 2,
                    strokeColor: Theme.of(context).scaffoldBackgroundColor,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withOpacity(0.2),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final dates = historicalData.keys.toList();
                  final date = dates[spot.x.toInt()];
                  return LineTooltipItem(
                    '$date\n${spot.y.toStringAsFixed(4)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    final entries = historicalData.entries.toList();
    final List<FlSpot> spots = [];

    for (int i = 0; i < entries.length; i++) {
      spots.add(FlSpot(i.toDouble(), entries[i].value));
    }

    return spots;
  }
}