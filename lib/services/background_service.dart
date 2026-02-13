import 'package:workmanager/workmanager.dart';
import '../core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Fetch exchange rates
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString(AppConstants.apiKeyStorageKey);
      final baseCurrency = prefs.getString(AppConstants.baseCurrencyKey) ?? 
                          AppConstants.defaultBaseCurrency;

      if (apiKey != null) {
        final url = Uri.parse(
          '${AppConstants.apiBaseUrl}/$apiKey/latest/$baseCurrency',
        );
        
        final response = await http.get(url);
        
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          
          // Cache the data
          await prefs.setString(
            AppConstants.exchangeRatesKey,
            response.body,
          );
          
          await prefs.setInt(
            AppConstants.lastUpdateKey,
            DateTime.now().millisecondsSinceEpoch,
          );
          
          // Save snapshot
          final snapshotsJson = prefs.getString(AppConstants.snapshotsKey);
          List<dynamic> snapshots = [];
          
          if (snapshotsJson != null) {
            snapshots = jsonDecode(snapshotsJson);
          }
          
          snapshots.add({
            'date': DateTime.now().toIso8601String(),
            'base_currency': baseCurrency,
            'rates': json['conversion_rates'],
          });
          
          // Keep only last 365 days
          if (snapshots.length > 365) {
            snapshots = snapshots.sublist(snapshots.length - 365);
          }
          
          await prefs.setString(
            AppConstants.snapshotsKey,
            jsonEncode(snapshots),
          );
        }
      }

      return Future.value(true);
    } catch (e) {
      print('Background task error: $e');
      return Future.value(false);
    }
  });
}

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  Future<void> registerDailyUpdate() async {
    await Workmanager().registerPeriodicTask(
      AppConstants.backgroundTaskName,
      AppConstants.backgroundTaskName,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  Future<void> cancelDailyUpdate() async {
    await Workmanager().cancelByUniqueName(AppConstants.backgroundTaskName);
  }

  Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}