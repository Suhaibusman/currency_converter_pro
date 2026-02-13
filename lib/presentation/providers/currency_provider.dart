import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/network_info.dart';
import '../../data/datasources/local/currency_local_datasource.dart';
import '../../data/datasources/remote/currency_remote_datasource.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../domain/entities/currency_rate.dart';
import '../../domain/entities/conversion_history.dart';
import '../../domain/entities/snapshot.dart';
import '../../domain/usecases/convert_currency.dart';
import '../../domain/usecases/get_exchange_rates.dart';
import '../../domain/usecases/get_historical_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Repository Provider
final currencyRepositoryProvider = Provider((ref) {
  return CurrencyRepositoryImpl(
    remoteDataSource: CurrencyRemoteDataSourceImpl(
      client: http.Client(),
      supabaseClient: Supabase.instance.client,
    ),
    localDataSource: CurrencyLocalDataSourceImpl(
      ref.watch(sharedPreferencesProvider),
    ),
    networkInfo: NetworkInfoImpl(Connectivity()),
  );
});

// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Use Cases
final getExchangeRatesProvider = Provider((ref) {
  return GetExchangeRates(ref.watch(currencyRepositoryProvider));
});

final convertCurrencyProvider = Provider((ref) {
  return ConvertCurrency();
});

final getHistoricalDataProvider = Provider((ref) {
  return GetHistoricalData(ref.watch(currencyRepositoryProvider));
});

// State Providers
final baseCurrencyProvider = StateProvider<String>((ref) => 'USD');

final selectedCurrenciesProvider = StateProvider<List<String>>((ref) {
  return ['USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD'];
});

final amountProvider = StateProvider<double>((ref) => 1.0);

// Currency Rates Provider
final currencyRatesProvider = FutureProvider<CurrencyRate>((ref) async {
  final baseCurrency = ref.watch(baseCurrencyProvider);
  final useCase = ref.watch(getExchangeRatesProvider);
  
  final result = await useCase(baseCurrency);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (rates) => rates,
  );
});

// Conversion Results Provider
final conversionResultsProvider = Provider<Map<String, double>>((ref) {
  final rates = ref.watch(currencyRatesProvider);
  final baseCurrency = ref.watch(baseCurrencyProvider);
  final selectedCurrencies = ref.watch(selectedCurrenciesProvider);
  final amount = ref.watch(amountProvider);
  final convertUseCase = ref.watch(convertCurrencyProvider);
  
  return rates.when(
    data: (ratesData) {
      return convertUseCase.convertToMultiple(
        rates: ratesData,
        from: baseCurrency,
        toCurrencies: selectedCurrencies,
        amount: amount,
      );
    },
    loading: () => {},
    error: (_, __) => {},
  );
});

// Conversion History Provider
final conversionHistoryProvider = 
    FutureProvider<List<ConversionHistory>>((ref) async {
  final repository = ref.watch(currencyRepositoryProvider);
  final result = await repository.getConversionHistory();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (history) => history,
  );
});

// Historical Snapshots Provider
final historicalSnapshotsProvider = FutureProvider<List<Snapshot>>((ref) async {
  final repository = ref.watch(currencyRepositoryProvider);
  final result = await repository.getSnapshots();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (snapshots) => snapshots,
  );
});

// Favorite Pairs Provider
final favoritePairsProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(currencyRepositoryProvider);
  final result = await repository.getFavoritePairs();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (pairs) => pairs,
  );
});

// Recent Searches Provider
final recentSearchesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(currencyRepositoryProvider);
  final result = await repository.getRecentSearches();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (searches) => searches,
  );
});

// Network Status Provider
final networkStatusProvider = StreamProvider<bool>((ref) {
  return NetworkInfoImpl(Connectivity()).onConnectivityChanged;
});