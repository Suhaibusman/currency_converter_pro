import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/alert.dart';
import '../../domain/usecases/manage_alerts.dart';
import 'currency_provider.dart';

// Manage Alerts Use Case Provider
final manageAlertsProvider = Provider((ref) {
  return ManageAlerts(ref.watch(currencyRepositoryProvider));
});

// Alerts Provider
final alertsProvider = FutureProvider<List<Alert>>((ref) async {
  final useCase = ref.watch(manageAlertsProvider);
  final result = await useCase.getAlerts();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (alerts) => alerts,
  );
});

// Alert Actions Provider
final alertActionsProvider = Provider((ref) {
  return AlertActions(ref);
});

class AlertActions {
  final Ref ref;

  AlertActions(this.ref);

  Future<void> saveAlert(Alert alert) async {
    final useCase = ref.read(manageAlertsProvider);
    await useCase.saveAlert(alert);
    ref.invalidate(alertsProvider);
  }

  Future<void> deleteAlert(String alertId) async {
    final useCase = ref.read(manageAlertsProvider);
    await useCase.deleteAlert(alertId);
    ref.invalidate(alertsProvider);
  }

  Future<void> updateAlert(Alert alert) async {
    final useCase = ref.read(manageAlertsProvider);
    await useCase.updateAlert(alert);
    ref.invalidate(alertsProvider);
  }

  Future<void> toggleAlert(Alert alert) async {
    final updated = alert.copyWith(isActive: !alert.isActive);
    await updateAlert(updated);
  }
}
