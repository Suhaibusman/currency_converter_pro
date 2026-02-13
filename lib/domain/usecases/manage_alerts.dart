import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/alert.dart';
import '../repositories/currency_repository.dart';

class ManageAlerts {
  final CurrencyRepository repository;

  ManageAlerts(this.repository);

  Future<Either<Failure, List<Alert>>> getAlerts() async {
    return await repository.getAlerts();
  }
  
  Future<Either<Failure, void>> saveAlert(Alert alert) async {
    return await repository.saveAlert(alert);
  }
  
  Future<Either<Failure, void>> deleteAlert(String alertId) async {
    return await repository.deleteAlert(alertId);
  }
  
  Future<Either<Failure, void>> updateAlert(Alert alert) async {
    return await repository.updateAlert(alert);
  }
  
  List<Alert> checkAlerts(List<Alert> alerts, Map<String, double> currentRates) {
    final triggeredAlerts = <Alert>[];
    
    for (final alert in alerts) {
      if (!alert.isEnabled) continue;
      
      final rate = _getRate(alert.fromCurrency, alert.toCurrency, currentRates);
      if (rate == null) continue;
      
      bool triggered = false;
      
      switch (alert.type) {
        case AlertType.above:
          triggered = rate > alert.threshold;
          break;
        case AlertType.below:
          triggered = rate < alert.threshold;
          break;
        case AlertType.percentageChange:
          // Would need previous rate to calculate
          break;
      }
      
      if (triggered) {
        triggeredAlerts.add(alert);
      }
    }
    
    return triggeredAlerts;
  }
  
  double? _getRate(String from, String to, Map<String, double> rates) {
    if (from == to) return 1.0;
    
    final fromRate = rates[from];
    final toRate = rates[to];
    
    if (fromRate == null || toRate == null) return null;
    
    return toRate / fromRate;
  }
}