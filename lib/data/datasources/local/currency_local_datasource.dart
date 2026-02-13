import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/alert_model.dart';
import '../../models/conversion_history_model.dart';
import '../../models/currency_rate_model.dart';
import '../../models/snapshot_model.dart';

abstract class CurrencyLocalDataSource {
  Future<void> cacheRates(CurrencyRateModel rates);
  Future<CurrencyRateModel> getCachedRates();
  Future<int?> getLastUpdateTimestamp();
  Future<void> saveSnapshot(SnapshotModel snapshot);
  Future<List<SnapshotModel>> getSnapshots();
  Future<void> addConversionHistory(ConversionHistoryModel history);
  Future<List<ConversionHistoryModel>> getConversionHistory();
  Future<void> clearConversionHistory();
  Future<void> addAlert(AlertModel alert);
  Future<List<AlertModel>> getAlerts();
  Future<void> updateAlert(AlertModel alert);
  Future<void> deleteAlert(String alertId);
  Future<void> addFavoritePair(String pair);
  Future<List<String>> getFavoritePairs();
  Future<void> removeFavoritePair(String pair);
  Future<void> addRecentSearch(String search);
  Future<List<String>> getRecentSearches();
  Future<String?> getCachedApiKey();
  Future<void> cacheApiKey(String apiKey);
}

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final SharedPreferences sharedPreferences;

  CurrencyLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheRates(CurrencyRateModel rates) async {
    try {
      await sharedPreferences.setString(
        AppConstants.cacheKeyRates,
        json.encode(rates.toJson()),
      );
      await sharedPreferences.setInt(
        AppConstants.cacheKeyTimestamp,
        rates.timestamp,
      );
    } catch (e) {
      throw CacheException('Failed to cache rates: $e');
    }
  }

  @override
  Future<CurrencyRateModel> getCachedRates() async {
    try {
      final cachedString = sharedPreferences.getString(AppConstants.cacheKeyRates);
      
      if (cachedString == null) {
        throw const CacheException('No cached rates found');
      }

      final jsonData = json.decode(cachedString) as Map<String, dynamic>;
      return CurrencyRateModel.fromJson(jsonData);
    } catch (e) {
      throw CacheException('Failed to get cached rates: $e');
    }
  }

  @override
  Future<int?> getLastUpdateTimestamp() async {
    return sharedPreferences.getInt(AppConstants.cacheKeyTimestamp);
  }

  @override
  Future<void> saveSnapshot(SnapshotModel snapshot) async {
    try {
      final snapshots = await getSnapshots();
      snapshots.add(snapshot);
      
      // Keep only last 365 days
      if (snapshots.length > AppConstants.maxSnapshots) {
        snapshots.removeRange(0, snapshots.length - AppConstants.maxSnapshots);
      }

      final jsonList = snapshots.map((s) => s.toJson()).toList();
      await sharedPreferences.setString(
        AppConstants.cacheKeySnapshots,
        json.encode(jsonList),
      );
    } catch (e) {
      throw CacheException('Failed to save snapshot: $e');
    }
  }

  @override
  Future<List<SnapshotModel>> getSnapshots() async {
    try {
      final snapshotsString = sharedPreferences.getString(AppConstants.cacheKeySnapshots);
      
      if (snapshotsString == null) return [];

      final jsonList = json.decode(snapshotsString) as List;
      return jsonList
          .map((json) => SnapshotModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get snapshots: $e');
    }
  }

  @override
  Future<void> addConversionHistory(ConversionHistoryModel history) async {
    try {
      final historyList = await getConversionHistory();
      historyList.insert(0, history);
      
      // Keep only last 100
      if (historyList.length > AppConstants.maxConversionHistory) {
        historyList.removeRange(
          AppConstants.maxConversionHistory,
          historyList.length,
        );
      }

      final jsonList = historyList.map((h) => h.toJson()).toList();
      await sharedPreferences.setString(
        AppConstants.cacheKeyConversionHistory,
        json.encode(jsonList),
      );
    } catch (e) {
      throw CacheException('Failed to add conversion history: $e');
    }
  }

  @override
  Future<List<ConversionHistoryModel>> getConversionHistory() async {
    try {
      final historyString = sharedPreferences.getString(
        AppConstants.cacheKeyConversionHistory,
      );
      
      if (historyString == null) return [];

      final jsonList = json.decode(historyString) as List;
      return jsonList
          .map((json) =>
              ConversionHistoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get conversion history: $e');
    }
  }

  @override
  Future<void> clearConversionHistory() async {
    try {
      await sharedPreferences.remove(AppConstants.cacheKeyConversionHistory);
    } catch (e) {
      throw CacheException('Failed to clear conversion history: $e');
    }
  }

  @override
  Future<void> addAlert(AlertModel alert) async {
    try {
      final alerts = await getAlerts();
      alerts.add(alert);

      final jsonList = alerts.map((a) => a.toJson()).toList();
      await sharedPreferences.setString(
        AppConstants.cacheKeyAlerts,
        json.encode(jsonList),
      );
    } catch (e) {
      throw CacheException('Failed to add alert: $e');
    }
  }

  @override
  Future<List<AlertModel>> getAlerts() async {
    try {
      final alertsString = sharedPreferences.getString(AppConstants.cacheKeyAlerts);
      
      if (alertsString == null) return [];

      final jsonList = json.decode(alertsString) as List;
      return jsonList
          .map((json) => AlertModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get alerts: $e');
    }
  }

  @override
  Future<void> updateAlert(AlertModel alert) async {
    try {
      final alerts = await getAlerts();
      final index = alerts.indexWhere((a) => a.id == alert.id);
      
      if (index != -1) {
        alerts[index] = alert;
        final jsonList = alerts.map((a) => a.toJson()).toList();
        await sharedPreferences.setString(
          AppConstants.cacheKeyAlerts,
          json.encode(jsonList),
        );
      }
    } catch (e) {
      throw CacheException('Failed to update alert: $e');
    }
  }

  @override
  Future<void> deleteAlert(String alertId) async {
    try {
      final alerts = await getAlerts();
      alerts.removeWhere((a) => a.id == alertId);

      final jsonList = alerts.map((a) => a.toJson()).toList();
      await sharedPreferences.setString(
        AppConstants.cacheKeyAlerts,
        json.encode(jsonList),
      );
    } catch (e) {
      throw CacheException('Failed to delete alert: $e');
    }
  }

  @override
  Future<void> addFavoritePair(String pair) async {
    try {
      final pairs = await getFavoritePairs();
      if (!pairs.contains(pair)) {
        pairs.add(pair);
        await sharedPreferences.setStringList(
          AppConstants.cacheKeyFavoritePairs,
          pairs,
        );
      }
    } catch (e) {
      throw CacheException('Failed to add favorite pair: $e');
    }
  }

  @override
  Future<List<String>> getFavoritePairs() async {
    return sharedPreferences.getStringList(AppConstants.cacheKeyFavoritePairs) ?? [];
  }

  @override
  Future<void> removeFavoritePair(String pair) async {
    try {
      final pairs = await getFavoritePairs();
      pairs.remove(pair);
      await sharedPreferences.setStringList(
        AppConstants.cacheKeyFavoritePairs,
        pairs,
      );
    } catch (e) {
      throw CacheException('Failed to remove favorite pair: $e');
    }
  }

  @override
  Future<void> addRecentSearch(String search) async {
    try {
      final searches = await getRecentSearches();
      searches.remove(search); // Remove if exists
      searches.insert(0, search);
      
      // Keep only last 20
      if (searches.length > AppConstants.maxRecentSearches) {
        searches.removeRange(
          AppConstants.maxRecentSearches,
          searches.length,
        );
      }

      await sharedPreferences.setStringList(
        AppConstants.cacheKeyRecentSearches,
        searches,
      );
    } catch (e) {
      throw CacheException('Failed to add recent search: $e');
    }
  }

  @override
  Future<List<String>> getRecentSearches() async {
    return sharedPreferences.getStringList(AppConstants.cacheKeyRecentSearches) ?? [];
  }

  @override
  Future<String?> getCachedApiKey() async {
    return sharedPreferences.getString(AppConstants.cacheKeyApiKey);
  }

  @override
  Future<void> cacheApiKey(String apiKey) async {
    try {
      await sharedPreferences.setString(AppConstants.cacheKeyApiKey, apiKey);
    } catch (e) {
      throw CacheException('Failed to cache API key: $e');
    }
  }
}