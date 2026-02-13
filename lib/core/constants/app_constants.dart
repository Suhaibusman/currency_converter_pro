class AppConstants {
  // App Info
  static const String appName = 'Currency Converter Pro';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Live Rates - Offline First Currency Converter';
  
  // Supabase Configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  static const String apiKeyTable = 'api_keys';
  static const String apiKeyColumn = 'exchange_rate_api_key';
  
  // Exchange Rate API
  static const String exchangeRateApiBaseUrl = 'https://v6.exchangerate-api.com/v6';
  static const String exchangeRateApiEndpoint = '/latest';
   static const String baseCurrencyKey = 'base_currency';
  static const String homeCurrencyKey = 'home_currency';
  // Storage Keys
  static const String apiKeyKey = 'api_key';
  static const String exchangeRatesKey = 'exchange_rates';
  static const String lastUpdateKey = 'last_update';
  static const String selectedCurrenciesKey = 'selected_currencies';
  static const String themeKey = 'theme';
  static const String customColorKey = 'custom_color';
  static const String fontSizeKey = 'font_size';
  static const String decimalPrecisionKey = 'decimal_precision';
  static const String roundingModeKey = 'rounding_mode';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String languageKey = 'language';
  
  // Cache Keys
  static const String cacheKeyRates = 'cached_rates';
  static const String cacheKeyTimestamp = 'last_update_timestamp';
  static const String cacheKeyApiKey = 'api_key';
  static const String cacheKeyBaseCurrency = 'base_currency';
  static const String cacheKeyHomeCurrency = 'home_currency';
  static const String cacheKeySelectedCurrencies = 'selected_currencies';
  static const String cacheKeyTheme = 'theme';
  static const String cacheKeyCustomColor = 'custom_color';
  static const String cacheKeyFontSize = 'font_size';
  static const String cacheKeyDecimalPrecision = 'decimal_precision';
  static const String cacheKeyRoundingMode = 'rounding_mode';
  static const String cacheKeyBiometric = 'biometric_enabled';
  static const String cacheKeyLanguage = 'language';
  static const String cacheKeyConversionHistory = 'conversion_history';
  static const String cacheKeySnapshots = 'snapshots';
  static const String cacheKeyAlerts = 'alerts';
  static const String cacheKeyFavoritePairs = 'favorite_pairs';
  static const String cacheKeyRecentSearches = 'recent_searches';
  
  // Update Interval
  static const int updateIntervalHours = 24;
  static const int updateIntervalMilliseconds = updateIntervalHours * 60 * 60 * 1000;
  
  // Background Task
  static const String backgroundTaskName = 'currency_update_task';
  static const String backgroundTaskTag = 'currency_update';
  
  // Notification
  static const String notificationChannelId = 'currency_alerts';
  static const String notificationChannelName = 'Currency Alerts';
  static const String notificationChannelDescription = 'Notifications for currency rate alerts';
  
  // Widget
  static const String widgetName = 'CurrencyWidget';
  static const String widgetAndroidName = 'CurrencyWidgetProvider';
  
  // Defaults
  static const String defaultBaseCurrency = 'USD';
  static const String defaultHomeCurrency = 'USD';
  static const String defaultTheme = 'midnight_luxe';
  static const double defaultFontSize = 16.0;
  static const int defaultDecimalPrecision = 2;
  static const String defaultRoundingMode = 'half_up';
  static const String defaultLanguage = 'en';
  
  // Limits
  static const int maxConversionHistory = 100;
  static const int maxRecentSearches = 20;
  static const int maxFavoritePairs = 50;
  static const int maxSnapshots = 365; // 1 year
  static const int maxAlerts = 50;
  
  // Chart
  static const int chartPoints7Days = 7;
  static const int chartPoints30Days = 30;
  static const int chartPoints90Days = 90;
  
  // Decimal Precision Range
  static const int minDecimalPrecision = 2;
  static const int maxDecimalPrecision = 8;
  
  // Font Size Range
  static const double minFontSize = 12.0;
  static const double maxFontSize = 24.0;
  
  // Theme Names
  static const List<String> themeNames = [
    'neon_pulse',
    'midnight_luxe',
    'frost_aura',
    'sahara_glow',
    'emerald_wave',
    'golden_horizon',
    'ocean_prism',
    'sunset_ember',
    'sky_nova',
    'system_sync',
    'custom',
  ];
  
  // Rounding Modes
  static const List<String> roundingModes = [
    'half_up',
    'down',
    'up',
    'ceiling',
    'floor',
  ];
  
  // Languages
  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'zh', 'name': '中文'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'ar', 'name': 'العربية'},
    {'code': 'hi', 'name': 'हिन्दी'},
    {'code': 'ur', 'name': 'اردو'},
  ];
  
  // Alert Types
  static const String alertTypeAbove = 'above';
  static const String alertTypeBelow = 'below';
  static const String alertTypePercentageChange = 'percentage_change';
  
  // Export
  static const String exportFileNamePrefix = 'currency_conversion';
  static const String exportFileExtensionCsv = 'csv';
  static const String exportFileExtensionPng = 'png';
  
  // URLs
  static const String privacyPolicyUrl = 'https://your-privacy-policy-url.com';
  static const String termsOfServiceUrl = 'https://your-terms-url.com';
  static const String hireMeUrl = 'https://your-portfolio-url.com';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.yourcompany.currency_converter_pro';
  
  // Error Messages
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorCache = 'Failed to load cached data.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorUnknown = 'An unknown error occurred.';
  static const String errorNoCachedData = 'No cached data available. Please connect to the internet.';
  static const String errorInvalidApiKey = 'Invalid API key. Please check your configuration.';
  static const String errorBiometric = 'Biometric authentication failed.';
  
  // Success Messages
  static const String successRateUpdate = 'Exchange rates updated successfully';
  static const String successAlertCreated = 'Alert created successfully';
  static const String successAlertDeleted = 'Alert deleted successfully';
  static const String successPairAdded = 'Pair added to favorites';
  static const String successPairRemoved = 'Pair removed from favorites';
  static const String successExported = 'Data exported successfully';
  static const String successCacheCleared = 'Cache cleared successfully';
  
  // Haptic Feedback
  static const bool enableHapticFeedback = true;
  
  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
  
  // Refresh
  static const Duration refreshDebounce = Duration(milliseconds: 500);
}