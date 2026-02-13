import 'package:home_widget/home_widget.dart';
import '../core/constants/app_constants.dart';
import 'dart:convert';

class WidgetService {
  static final WidgetService _instance = WidgetService._internal();
  factory WidgetService() => _instance;
  WidgetService._internal();

  Future<void> initialize() async {
    await HomeWidget.setAppGroupId('group.currency_converter_pro');
  }

  Future<void> updateWidget(Map<String, dynamic> rates, List<String> currencies) async {
    try {
      // Save data for widget
      await HomeWidget.saveWidgetData<String>(
        'rates',
        jsonEncode(rates),
      );
      
      await HomeWidget.saveWidgetData<String>(
        'currencies',
        jsonEncode(currencies),
      );
      
      await HomeWidget.saveWidgetData<String>(
        'lastUpdate',
        DateTime.now().toIso8601String(),
      );

      // Update widget
      await HomeWidget.updateWidget(
        name: AppConstants.widgetName,
        iOSName: AppConstants.widgetName,
      );
    } catch (e) {
      print('Widget update error: $e');
    }
  }

  Future<void> clearWidgetData() async {
    await HomeWidget.saveWidgetData<String>('rates', '');
    await HomeWidget.saveWidgetData<String>('currencies', '');
  }
}