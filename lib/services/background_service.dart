import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

import '../core/constants/app_constants.dart';
import '../core/network/network_info.dart';
import '../data/datasources/local/currency_local_datasource.dart';
import '../data/datasources/remote/currency_remote_datasource.dart';
import '../data/repositories/currency_repository_impl.dart';
import '../domain/entities/alert.dart';
import 'notification_service.dart';
import 'widget_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // 1. Initialize dependencies
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );

      final sharedPreferences = await SharedPreferences.getInstance();
      final notificationService = NotificationService();
      await notificationService.initialize();

      // 2. Setup Repository
      final localDataSource = CurrencyLocalDataSourceImpl(sharedPreferences);
      final remoteDataSource = CurrencyRemoteDataSourceImpl(
        client: http.Client(),
        supabaseClient: Supabase.instance.client,
      );

      final repository = CurrencyRepositoryImpl(
        localDataSource: localDataSource,
        remoteDataSource: remoteDataSource,
        networkInfo: _SimpleNetworkInfo(),
      );

      // 3. Update Rates
      final baseCurrency =
          sharedPreferences.getString(AppConstants.baseCurrencyKey) ??
              AppConstants.defaultBaseCurrency;

      final ratesResult = await repository.getExchangeRates(baseCurrency);

      // 4. Check Alerts & Update Widget
      await ratesResult.fold(
        (failure) async {
          if (kDebugMode) {
            print('Background update failed: ${failure.message}');
          }
        },
        (rates) async {
          // Update Widget
          final widgetService = WidgetService();
          await widgetService.initialize();

          final selectedCurrenciesEncoded = sharedPreferences.getStringList(
                AppConstants.selectedCurrenciesKey,
              ) ??
              ['USD', 'EUR', 'GBP'];

          await widgetService.updateWidget(
            rates.rates,
            selectedCurrenciesEncoded,
          );

          // Check Alerts
          final alertsResult = await repository.getAlerts();

          await alertsResult.fold(
            (failure) => null,
            (alerts) async {
              for (final alert in alerts) {
                if (!alert.isActive) continue;

                final currentRate = rates.rates[alert.targetCurrency];
                if (currentRate == null) continue;

                bool triggered = false;
                String body = '';

                switch (alert.type) {
                  case AlertType.above:
                    if (currentRate > alert.targetRate) {
                      triggered = true;
                      body =
                          '${alert.targetCurrency} went above ${alert.targetRate}';
                    }
                    break;
                  case AlertType.below:
                    if (currentRate < alert.targetRate) {
                      triggered = true;
                      body =
                          '${alert.targetCurrency} dropped below ${alert.targetRate}';
                    }
                    break;
                  case AlertType.percentageChange:
                    // Requires previous rate, simpler implementation for now:
                    // Check if change from targetRate is significant
                    final change =
                        ((currentRate - alert.targetRate) / alert.targetRate)
                                .abs() *
                            100;
                    if (change >= 1.0) {
                      // 1% change
                      triggered = true;
                      body =
                          '${alert.targetCurrency} changed by ${change.toStringAsFixed(2)}%';
                    }
                    break;
                  case AlertType.change:
                    // Simple change alert
                    triggered = true;
                    body =
                        '1 ${alert.baseCurrency} = $currentRate ${alert.targetCurrency}';
                    break;
                }

                if (triggered) {
                  await notificationService.showAlertNotification(
                    title: 'Currency Alert: ${alert.targetCurrency}',
                    body: body,
                    id: alert.id.hashCode,
                  );

                  // Disable one-time alerts if needed, or update triggeredAt
                  // repository.updateAlert(alert.copyWith(triggeredAt: DateTime.now()));
                }
              }
            },
          );
        },
      );

      return Future.value(true);
    } catch (e) {
      if (kDebugMode) {
        print('Background task error: $e');
      }
      return Future.value(false);
    }
  });
}

class _SimpleNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    final result = await Connectivity().checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged.map((results) {
      return results.any((result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet);
    });
  }
}

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  Future<void> registerDailyUpdate() async {
    await Workmanager().registerPeriodicTask(
      AppConstants.backgroundTaskTag,
      AppConstants.backgroundTaskName,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}
