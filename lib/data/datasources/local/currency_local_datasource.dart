import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/currency_rate_model.dart';
import '../../models/alert_model.dart';
import '../../models/conversion_history_model.dart';
import '../../models/snapshot_model.dart';

abstract class CurrencyLocalDataSource {
  Future<CurrencyRateModel> getCachedRates();
  Future<void> cacheRates(CurrencyRateModel rates);
  Future<int> getLastUpdateTimestamp();
  Future<void> setLastUpdateTimestamp(int timestamp);
  Future<String> getApiKey();
  Future<void> cacheApiKey(String apiKey);
  
  Future<List<ConversionHistoryModel>> getConversionHistory();
  Future<void> addConversionHistory(ConversionHistoryModel history);
  Future<void> clearConversionHistory();
  
  Future<List<SnapshotModel>> getSnapshots();
  Future<void> saveSnapshot(SnapshotModel snapshot);
  
  Future<List<AlertModel>> getAlerts();
  Future<void> saveAlert(AlertModel alert);
  Future<void> deleteAlert(String alertId);
  
  Future<List<String>> getFavoritePairs();
  Future<void> addFavoritePair(String pair);
  Future<void> removeFavoritePair(String pair);
  
  Future<List<String>> getRecentSearches();
  Future<void> addRecentSearch(String currency);
}

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final SharedPreferences sharedPreferences;

  CurrencyLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<CurrencyRateModel> getCachedRates() async {
    final jsonString = sharedPreferences.getString(AppConstants.exchangeRatesKey);
    
    if (jsonString == null) {
      throw CacheException('No cached rates found');
    }
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return CurrencyRateModel.fromJson(json);
    } catch (e) {
      throw CacheException('Failed to decode cached rates: $e');
    }
  }

  @override
  Future<void> cacheRates(CurrencyRateModel rates) async {
    try {
      final jsonString = jsonEncode(rates.toJson());
      await sharedPreferences.setString(
        AppConstants.exchangeRatesKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to cache rates: $e');
    }
  }

  @override
  Future<int> getLastUpdateTimestamp() async {
    return sharedPreferences.getInt(AppConstants.lastUpdateKey) ?? 0;
  }

  @override
  Future<void> setLastUpdateTimestamp(int timestamp) async {
    await sharedPreferences.setInt(AppConstants.lastUpdateKey, timestamp);
  }

  @override
  Future<String> getApiKey() async {
    final apiKey = sharedPreferences.getString(AppConstants.apiKeyStorageKey);
    
    if (apiKey == null) {
      throw CacheException('No API key found');
    }
    
    return apiKey;
  }

  @override
  Future<void> cacheApiKey(String apiKey) async {
    await sharedPreferences.setString(AppConstants.apiKeyStorageKey, apiKey);
  }

  @override
  Future<List<ConversionHistoryModel>> getConversionHistory() async {
    final jsonString = sharedPreferences.getString(AppConstants.conversionHistoryKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => ConversionHistoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to decode conversion history: $e');
    }
  }

  @override
  Future<void> addConversionHistory(ConversionHistoryModel history) async {
    try {
      final historyList = await getConversionHistory();
      historyList.insert(0, history);
      
      // Keep only recent items
      if (historyList.length > AppConstants.maxHistoryItems) {
        historyList.removeRange(
          AppConstants.maxHistoryItems,
          historyList.length,
        );
      }
      
      final jsonString = jsonEncode(
        historyList.map((h) => h.toJson()).toList(),
      );
      
      await sharedPreferences.setString(
        AppConstants.conversionHistoryKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to add conversion history: $e');
    }
  }

  @override
  Future<void> clearConversionHistory() async {
    await sharedPreferences.remove(AppConstants.conversionHistoryKey);
  }

  @override
  Future<List<SnapshotModel>> getSnapshots() async {
    final jsonString = sharedPreferences.getString(AppConstants.snapshotsKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => SnapshotModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to decode snapshots: $e');
    }
  }

  @override
  Future<void> saveSnapshot(SnapshotModel snapshot) async {
    try {
      final snapshots = await getSnapshots();
      
      // Remove existing snapshot for the same date
      snapshots.removeWhere((s) => 
        s.date.year == snapshot.date.year &&
        s.date.month == snapshot.date.month &&
        s.date.day == snapshot.date.day
      );
      
      snapshots.add(snapshot);
      
      // Keep only last 365 days
      if (snapshots.length > 365) {
        snapshots.sort((a, b) => b.date.compareTo(a.date));
        snapshots.removeRange(365, snapshots.length);
      }
      
      final jsonString = jsonEncode(
        snapshots.map((s) => s.toJson()).toList(),
      );
      
      await sharedPreferences.setString(
        AppConstants.snapshotsKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to save snapshot: $e');
    }
  }

  @override
  Future<List<AlertModel>> getAlerts() async {
    final jsonString = sharedPreferences.getString(AppConstants.alertsKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => AlertModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to decode alerts: $e');
    }
  }

  @override
  Future<void> saveAlert(AlertModel alert) async {
    try {
      final alerts = await getAlerts();
      
      // Check if alert with same ID exists
      final index = alerts.indexWhere((a) => a.id == alert.id);
      
      if (index != -1) {
        alerts[index] = alert;
      } else {
        alerts.add(alert);
      }
      
      final jsonString = jsonEncode(
        alerts.map((a) => a.toJson()).toList(),
      );
      
      await sharedPreferences.setString(
        AppConstants.alertsKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to save alert: $e');
    }
  }

  @override
  Future<void> deleteAlert(String alertId) async {
    try {
      final alerts = await getAlerts();
      alerts.removeWhere((a) => a.id == alertId);
      
      final jsonString = jsonEncode(
        alerts.map((a) => a.toJson()).toList(),
      );
      
      await sharedPreferences.setString(
        AppConstants.alertsKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to delete alert: $e');
    }
  }

  @override
  Future<List<String>> getFavoritePairs() async {
    return sharedPreferences.getStringList(AppConstants.favoritePairsKey) ?? [];
  }

  @override
  Future<void> addFavoritePair(String pair) async {
    final pairs = await getFavoritePairs();
    
    if (!pairs.contains(pair)) {
      pairs.add(pair);
      
      if (pairs.length > AppConstants.maxFavoritePairs) {
        pairs.removeAt(0);
      }
      
      await sharedPreferences.setStringList(
        AppConstants.favoritePairsKey,
        pairs,
      );
    }
  }

  @override
  Future<void> removeFavoritePair(String pair) async {
    final pairs = await getFavoritePairs();
    pairs.remove(pair);
    
    await sharedPreferences.setStringList(
      AppConstants.favoritePairsKey,
      pairs,
    );
  }

  @override
  Future<List<String>> getRecentSearches() async {
    return sharedPreferences.getStringList(AppConstants.recentSearchesKey) ?? [];
  }

  @override
  Future<void> addRecentSearch(String currency) async {
    final searches = await getRecentSearches();
    
    // Remove if already exists
    searches.remove(currency);
    
    // Add to beginning
    searches.insert(0, currency);
    
    // Keep only recent
    if (searches.length > AppConstants.maxRecentSearches) {
      searches.removeRange(
        AppConstants.maxRecentSearches,
        searches.length,
      );
    }
    
    await sharedPreferences.setStringList(
      AppConstants.recentSearchesKey,
      searches,
    );
  }
}