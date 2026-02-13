import 'package:workmanager/workmanager.dart';
import '../core/constants/app_constants.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Background update logic here
    // This will be called daily to update exchange rates
    try {
      // Initialize services
      // Fetch new rates
      // Check alerts
      // Update widget
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  Future<void> registerDailyUpdate() async {
    await Workmanager().registerPeriodicTask(
      AppConstants.backgroundTaskTag,
      AppConstants.backgroundTaskName,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}