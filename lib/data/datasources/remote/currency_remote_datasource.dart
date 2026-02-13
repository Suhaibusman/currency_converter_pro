import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/currency_rate_model.dart';

abstract class CurrencyRemoteDataSource {
  Future<CurrencyRateModel> getExchangeRates(String baseCurrency);
  Future<String> getApiKey();
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;
  final SupabaseClient supabaseClient;

  CurrencyRemoteDataSourceImpl({
    required this.client,
    required this.supabaseClient,
  });

  @override
  Future<String> getApiKey() async {
    try {
      final response = await supabaseClient
          .from(AppConstants.apiKeyTable)
          .select(AppConstants.apiKeyColumn)
          .limit(1)
          .single();

      if (response[AppConstants.apiKeyColumn] != null) {
        return response[AppConstants.apiKeyColumn] as String;
      }
      
      throw const ServerException('API key not found in database');
    } catch (e) {
      throw ServerException('Failed to fetch API key: $e');
    }
  }

  @override
  Future<CurrencyRateModel> getExchangeRates(String baseCurrency) async {
    try {
      final apiKey = await getApiKey();
      
      final url = Uri.parse(
        '${AppConstants.exchangeRateApiBaseUrl}/$apiKey${AppConstants.exchangeRateApiEndpoint}/$baseCurrency',
      );

      final response = await client.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        if (jsonData['result'] == 'success') {
          return CurrencyRateModel.fromJson(jsonData);
        } else {
          throw ServerException(
            jsonData['error-type'] ?? 'Unknown error from API',
          );
        }
      } else if (response.statusCode == 401) {
        throw const InvalidApiKeyException();
      } else {
        throw ApiException(
          'Failed to fetch exchange rates',
          response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on InvalidApiKeyException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }
}