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
      child: MyApp(
        initialBiometricEnabled:
            sharedPreferences.getBool(AppConstants.biometricEnabledKey) ??
                false,
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final bool initialBiometricEnabled;

  const MyApp({
    super.key,
    required this.initialBiometricEnabled,
  });

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  late bool _isCheckingAuth;
  late bool _isAuthenticated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // meaningful initial state
    _isAuthenticated = !widget.initialBiometricEnabled;
    _isCheckingAuth = widget.initialBiometricEnabled;

    if (widget.initialBiometricEnabled) {
      _checkBiometricAuth();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-check preference in case it changed in settings while app was backgrounded (unlikely but possible)
      // or if we just want to re-auth on resume
      final biometricEnabled = ref.read(biometricEnabledProvider);

      if (biometricEnabled && _isAuthenticated) {
        setState(() {
          _isAuthenticated = false;
          _isCheckingAuth = true;
        });
        _checkBiometricAuth();
      }
    }
  }

  Future<void> _checkBiometricAuth() async {
    // Double check with latest provider state if available, but for now rely on logic
    final biometricService = BiometricService();
    final isAvailable = await biometricService.isAvailable();

    if (!isAvailable) {
      // Fallback if hardware not available
      if (mounted) {
        setState(() {
          _isAuthenticated = true;
          _isCheckingAuth = false;
        });
      }
      return;
    }

    final authenticated = await biometricService.authenticate();

    if (mounted) {
      setState(() {
        _isAuthenticated = authenticated;
        _isCheckingAuth = false;
      });
    }

    if (!authenticated) {
      // Keep on lock screen, user can retry
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeAsync = ref.watch(currentThemeProvider);
    final fontSizeAsync = ref.watch(fontSizeProvider);

    // Auth Loading Screen
    if (_isCheckingAuth) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black, // Dark background for loading
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.fingerprint, size: 80, color: Colors.blueAccent),
                SizedBox(height: 24),
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Verifying Identity...',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      );
    }

    // Auth Failed Screen
    if (!_isAuthenticated) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline,
                    size: 80, color: Colors.redAccent),
                const SizedBox(height: 24),
                const Text('Authentication Required',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isCheckingAuth = true;
                    });
                    _checkBiometricAuth();
                  },
                  child: const Text('Tap to Unlock'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Main App
    return themeAsync.when(
      data: (themeData) => MaterialApp(
        title: 'Currency Converter Pro',
        theme: themeData,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(fontSizeAsync / 16.0),
            ),
            child: child!,
          );
        },
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
