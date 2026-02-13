import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_constants.dart';
import 'presentation/providers/currency_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'services/background_service.dart';
import 'services/biometric_service.dart';
import 'services/notification_service.dart';
import 'services/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Services
  await NotificationService().initialize();
  await BackgroundService().initialize();
  await BackgroundService().registerDailyUpdate();
  await WidgetService().initialize();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkBiometric();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkBiometric();
    }
  }

  Future<void> _checkBiometric() async {
    final biometricEnabled = await ref
        .read(settingsRepositoryProvider)
        .getBiometricEnabled();
    
    biometricEnabled.fold(
      (failure) => null,
      (enabled) async {
        if (enabled) {
          final authenticated = await BiometricService().authenticate();
          if (!authenticated) {
            SystemNavigator.pop();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeAsync = ref.watch(currentThemeProvider);
    final fontSizeAsync = ref.watch(fontSizeProvider);

    return themeAsync.when(
      data: (themeData) => fontSizeAsync.when(
        data: (fontSize) => MaterialApp(
          title: 'Currency Converter Pro',
          theme: themeData,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        ),
        loading: () => const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
        error: (_, __) => MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Error loading font size'),
            ),
          ),
        ),
      ),
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'core/constants/app_constants.dart';
// import 'presentation/providers/currency_provider.dart';
// import 'presentation/providers/theme_provider.dart';
// import 'presentation/providers/settings_provider.dart';
// import 'presentation/screens/home_screen.dart';
// import 'services/background_service.dart';
// import 'services/biometric_service.dart';
// import 'services/notification_service.dart';
// import 'services/widget_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Supabase
//   await Supabase.initialize(
//     url: AppConstants.supabaseUrl,
//     anonKey: AppConstants.supabaseAnonKey,
//   );

//   // Initialize SharedPreferences
//   final sharedPreferences = await SharedPreferences.getInstance();

//   // Initialize Services
//   await NotificationService().initialize();
//   await BackgroundService().initialize();
//   await BackgroundService().registerDailyUpdate();
//   await WidgetService().initialize();

//   // Set system UI overlay style
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//       systemNavigationBarColor: Colors.transparent,
//     ),
//   );

//   // Set preferred orientations
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   runApp(
//     ProviderScope(
//       overrides: [
//         sharedPreferencesProvider.overrideWithValue(sharedPreferences),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends ConsumerStatefulWidget {
//   const MyApp({super.key});

//   @override
//   ConsumerState<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
//   bool _isAuthenticated = false;
//   bool _isCheckingAuth = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _checkBiometricAuth();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       final biometricEnabled = ref.read(biometricEnabledProvider);
//       if (biometricEnabled && _isAuthenticated) {
//         setState(() {
//           _isAuthenticated = false;
//           _isCheckingAuth = true;
//         });
//         _checkBiometricAuth();
//       }
//     }
//   }

//   Future<void> _checkBiometricAuth() async {
//     final biometricEnabled = ref.read(biometricEnabledProvider);

//     if (!biometricEnabled) {
//       setState(() {
//         _isAuthenticated = true;
//         _isCheckingAuth = false;
//       });
//       return;
//     }

//     final biometricService = BiometricService();
//     final isAvailable = await biometricService.isAvailable();

//     if (!isAvailable) {
//       setState(() {
//         _isAuthenticated = true;
//         _isCheckingAuth = false;
//       });
//       return;
//     }

//     final authenticated = await biometricService.authenticate(
//       reason: 'Authenticate to access Currency Converter Pro',
//     );

//     setState(() {
//       _isAuthenticated = authenticated;
//       _isCheckingAuth = false;
//     });

//     if (!authenticated) {
//       // Exit app if authentication fails
//       SystemNavigator.pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeData = ref.watch(themeDataProvider);
//     final fontSize = ref.watch(fontSizeProvider);

//     if (_isCheckingAuth) {
//       return MaterialApp(
//         home: Scaffold(
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.fingerprint,
//                   size: 80,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 const SizedBox(height: 24),
//                 const CircularProgressIndicator(),
//                 const SizedBox(height: 16),
//                 const Text('Authenticating...'),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     if (!_isAuthenticated) {
//       return MaterialApp(
//         home: Scaffold(
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(
//                   Icons.lock,
//                   size: 80,
//                   color: Colors.red,
//                 ),
//                 const SizedBox(height: 24),
//                 const Text('Authentication Failed'),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _isCheckingAuth = true;
//                     });
//                     _checkBiometricAuth();
//                   },
//                   child: const Text('Try Again'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return MaterialApp(
//       title: 'Currency Converter Pro',
//       debugShowCheckedModeBanner: false,
//       theme: themeData,
//       home: const HomeScreen(),
//       builder: (context, child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(
//             textScaler: TextScaler.linear(fontSize / 14.0),
//           ),
//           child: child!,
//         );
//       },
//     );
//   }
// }