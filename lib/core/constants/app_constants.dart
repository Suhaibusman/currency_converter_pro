class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://v6.exchangerate-api.com/v6';
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  static const String apiKeyTable = 'api_keys';
  
  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 24);
  
  // Storage Keys
  static const String exchangeRatesKey = 'exchange_rates';
  static const String lastUpdateKey = 'last_update_timestamp';
  static const String apiKeyStorageKey = 'api_key';
  static const String baseCurrencyKey = 'base_currency';
  static const String homeCurrencyKey = 'home_currency';
  static const String selectedCurrenciesKey = 'selected_currencies';
  static const String themeKey = 'theme_mode';
  static const String customColorKey = 'custom_color';
  static const String fontSizeKey = 'font_size';
  static const String conversionHistoryKey = 'conversion_history';
  static const String favoritePairsKey = 'favorite_pairs';
  static const String snapshotsKey = 'daily_snapshots';
  static const String alertsKey = 'alerts';
  static const String decimalPrecisionKey = 'decimal_precision';
  static const String roundingModeKey = 'rounding_mode';
  static const String recentSearchesKey = 'recent_searches';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String languageKey = 'language';
  
  // Default Values
  static const String defaultBaseCurrency = 'USD';
  static const int defaultDecimalPrecision = 4;
  static const int maxRecentSearches = 10;
  static const int maxHistoryItems = 100;
  static const int maxFavoritePairs = 20;
  
  // Notification
  static const String notificationChannelId = 'currency_alerts';
  static const String notificationChannelName = 'Currency Alerts';
  static const String notificationChannelDescription = 'Alerts for currency rate changes';
  
  // Background Task
  static const String backgroundTaskName = 'currency_update_task';
  
  // Widget
  static const String widgetName = 'CurrencyWidgetProvider';
  
  // Popular Currencies
  static const List<String> popularCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY', 'HKD', 'NZD',
    'SEK', 'KRW', 'SGD', 'NOK', 'MXN', 'INR', 'RUB', 'ZAR', 'TRY', 'BRL',
    'TWD', 'DKK', 'PLN', 'THB', 'IDR', 'HUF', 'CZK', 'ILS', 'CLP', 'PHP',
    'AED', 'SAR', 'MYR', 'RON', 'PKR', 'EGP', 'ARS', 'VND', 'BDT', 'NGN'
  ];
  
  // Currency Symbols
  static const Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'AUD': 'A\$',
    'CAD': 'C\$',
    'CHF': 'Fr',
    'CNY': '¥',
    'HKD': 'HK\$',
    'NZD': 'NZ\$',
    'INR': '₹',
    'RUB': '₽',
    'BRL': 'R\$',
    'PKR': '₨',
    'AED': 'د.إ',
    'SAR': '﷼',
  };
  
  // Currency Names
  static const Map<String, String> currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'HKD': 'Hong Kong Dollar',
    'NZD': 'New Zealand Dollar',
    'SEK': 'Swedish Krona',
    'KRW': 'South Korean Won',
    'SGD': 'Singapore Dollar',
    'NOK': 'Norwegian Krone',
    'MXN': 'Mexican Peso',
    'INR': 'Indian Rupee',
    'RUB': 'Russian Ruble',
    'ZAR': 'South African Rand',
    'TRY': 'Turkish Lira',
    'BRL': 'Brazilian Real',
    'TWD': 'Taiwan Dollar',
    'DKK': 'Danish Krone',
    'PLN': 'Polish Zloty',
    'THB': 'Thai Baht',
    'IDR': 'Indonesian Rupiah',
    'HUF': 'Hungarian Forint',
    'CZK': 'Czech Koruna',
    'ILS': 'Israeli Shekel',
    'CLP': 'Chilean Peso',
    'PHP': 'Philippine Peso',
    'AED': 'UAE Dirham',
    'SAR': 'Saudi Riyal',
    'MYR': 'Malaysian Ringgit',
    'RON': 'Romanian Leu',
    'PKR': 'Pakistani Rupee',
    'EGP': 'Egyptian Pound',
    'ARS': 'Argentine Peso',
    'VND': 'Vietnamese Dong',
    'BDT': 'Bangladeshi Taka',
    'NGN': 'Nigerian Naira',
  };
}