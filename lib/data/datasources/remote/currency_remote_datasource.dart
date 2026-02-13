import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/currency_rate_model.dart';

abstract class CurrencyRemoteDataSource {
  Future<CurrencyRateModel> getExchangeRates(String baseCurrency, String apiKey);
  Future<String> fetchApiKeyFromSupabase();
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;
  final SupabaseClient supabaseClient;

  CurrencyRemoteDataSourceImpl({
    required this.client,
    required this.supabaseClient,
  });

  @override
  Future<CurrencyRateModel> getExchangeRates(
    String baseCurrency,
    String apiKey,
  ) async {
    try {
      final url = Uri.parse(
        '${AppConstants.apiBaseUrl}/$apiKey/latest/$baseCurrency',
      );
      
      final response = await client.get(url);
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (json['result'] == 'success') {
          return CurrencyRateModel.fromJson(json);
        } else {
          throw ServerException('API returned error: ${json['error-type']}');
        }
      } else {
        throw ServerException(
          'Failed to fetch rates. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<String> fetchApiKeyFromSupabase() async {
    try {
      final response = await supabaseClient
          .from(AppConstants.apiKeyTable)
          .select('api_key')
          .single();
      
      if (response['api_key'] != null) {
        return response['api_key'] as String;
      } else {
        throw AuthException('API key not found in database');
      }
    } catch (e) {
      throw AuthException('Failed to fetch API key: $e');
    }
  }
}