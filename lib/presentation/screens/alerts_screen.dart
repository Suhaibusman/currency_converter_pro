import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/alert.dart';
import '../providers/alert_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/currency_selector.dart';
import '../providers/currency_provider.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  void _showAddAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddAlertDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(alertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Alerts'),
      ),
      body: alertsAsync.when(
        data: (alerts) {
          if (alerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No alerts set',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to create your first alert',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return _buildAlertCard(alert);
            },
          );
        },
        loading: () => const LoadingWidget(message: 'Loading alerts...'),
        error: (error, stack) => ErrorWidget(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(alertsProvider);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAlertDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAlertCard(Alert alert) {
    final actions = ref.read(alertActionsProvider);

    return Dismissible(
      key: Key(alert.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        actions.deleteAlert(alert.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(
            _getAlertIcon(alert.type),
            color: alert.isEnabled
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          title: Text(
            '${alert.fromCurrency}/${alert.toCurrency}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(alert.description),
          trailing: Switch(
            value: alert.isEnabled,
            onChanged: (value) {
              actions.toggleAlert(alert);
            },
          ),
        ),
      ),
    );
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.above:
        return Icons.arrow_upward;
      case AlertType.below:
        return Icons.arrow_downward;
      case AlertType.percentageChange:
        return Icons.percent;
    }
  }
}

class AddAlertDialog extends ConsumerStatefulWidget {
  const AddAlertDialog({super.key});

  @override
  ConsumerState<AddAlertDialog> createState() => _AddAlertDialogState();
}

class _AddAlertDialogState extends ConsumerState<AddAlertDialog> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  AlertType _alertType = AlertType.above;
  final _thresholdController = TextEditingController();

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  void _showCurrencySelector(bool isFrom) async {
    final recentSearches = await ref.read(recentSearchesProvider.future);
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencySelector(
        selectedCurrency: isFrom ? _fromCurrency : _toCurrency,
        onCurrencySelected: (currency) {
          setState(() {
            if (isFrom) {
              _fromCurrency = currency;
            } else {
              _toCurrency = currency;
            }
          });
        },
        recentSearches: recentSearches,
      ),
    );
  }

  void _saveAlert() {
    final threshold = double.tryParse(_thresholdController.text);
    if (threshold == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid threshold')),
      );
      return;
    }

    final alert = Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromCurrency: _fromCurrency,
      toCurrency: _toCurrency,
      type: _alertType,
      threshold: threshold,
      isEnabled: true,
      createdAt: DateTime.now(),
    );

    ref.read(alertActionsProvider).saveAlert(alert);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert created')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Alert'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCurrencySelector(true),
                    child: Text(_fromCurrency),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCurrencySelector(false),
                    child: Text(_toCurrency),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AlertType>(
              value: _alertType,
              decoration: const InputDecoration(
                labelText: 'Alert Type',
              ),
              items: AlertType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getAlertTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _alertType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _thresholdController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: _alertType == AlertType.percentageChange
                    ? 'Percentage (%)'
                    : 'Threshold Rate',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAlert,
          child: const Text('Create'),
        ),
      ],
    );
  }

  String _getAlertTypeName(AlertType type) {
    switch (type) {
      case AlertType.above:
        return 'Rate goes above';
      case AlertType.below:
        return 'Rate goes below';
      case AlertType.percentageChange:
        return 'Percentage change';
    }
  }
}