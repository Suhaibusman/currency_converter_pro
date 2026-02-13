import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/theme_constants.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/currency_provider.dart';
import '../widgets/currency_selector.dart';
import '../../services/biometric_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final BiometricService _biometricService = BiometricService();

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...AppThemeMode.values.map((mode) {
              return ListTile(
                title: Text(_getThemeName(mode)),
                leading: Icon(
                  Icons.palette,
                  color: _getThemeColor(mode),
                ),
                trailing: ref.watch(themeModeProvider) == mode
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref.read(themeModeProvider.notifier).setTheme(mode);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getThemeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.neonPulse:
        return 'Neon Pulse';
      case AppThemeMode.midnightLuxe:
        return 'Midnight Luxe';
      case AppThemeMode.frostAura:
        return 'Frost Aura';
      case AppThemeMode.saharaGlow:
        return 'Sahara Glow';
      case AppThemeMode.emeraldWave:
        return 'Emerald Wave';
      case AppThemeMode.goldenHorizon:
        return 'Golden Horizon';
      case AppThemeMode.oceanPrism:
        return 'Ocean Prism';
      case AppThemeMode.sunsetEmber:
        return 'Sunset Ember';
      case AppThemeMode.skyNova:
        return 'Sky Nova';
      case AppThemeMode.systemSync:
        return 'System Sync';
      case AppThemeMode.custom:
        return 'Custom';
    }
  }

  Color _getThemeColor(AppThemeMode mode) {
    if (mode == AppThemeMode.systemSync) {
      return Theme.of(context).colorScheme.primary;
    }
    if (mode == AppThemeMode.custom) {
      return ref.watch(customColorProvider);
    }
    return ThemeConstants.themes[mode]!.primary;
  }

  void _showBaseCurrencySelector() async {
    final recentSearches = await ref.read(recentSearchesProvider.future);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencySelector(
        selectedCurrency: ref.read(baseCurrencyProvider),
        onCurrencySelected: (currency) {
          ref.read(baseCurrencyProvider.notifier).setBaseCurrency(currency);
        },
        recentSearches: recentSearches,
      ),
    );
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      final isAvailable = await _biometricService.isAvailable();
      if (!isAvailable) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication not available'),
          ),
        );
        return;
      }

      final authenticated = await _biometricService.authenticate();
      if (authenticated) {
        ref.read(biometricEnabledProvider.notifier).setBiometric(true);
      }
    } else {
      ref.read(biometricEnabledProvider.notifier).setBiometric(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final decimalPrecision = ref.watch(decimalPrecisionProvider);
    final roundingMode = ref.watch(roundingModeProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final baseCurrency = ref.watch(baseCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            'Appearance',
            [
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                subtitle: Text(_getThemeName(themeMode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showThemeSelector,
              ),
              ListTile(
                leading: const Icon(Icons.format_size),
                title: const Text('Font Size'),
                subtitle: Slider(
                  value: fontSize,
                  min: 12,
                  max: 20,
                  divisions: 8,
                  label: fontSize.round().toString(),
                  onChanged: (value) {
                    ref.read(fontSizeProvider.notifier).setFontSize(value);
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            'Currency',
            [
              ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: const Text('Base Currency'),
                subtitle: Text(baseCurrency),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showBaseCurrencySelector,
              ),
              ListTile(
                leading: const Icon(Icons.plus_one),
                title: const Text('Decimal Precision'),
                subtitle: Text('$decimalPrecision decimal places'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: decimalPrecision > 2
                          ? () => ref
                              .read(decimalPrecisionProvider.notifier)
                              .setPrecision(decimalPrecision - 1)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: decimalPrecision < 8
                          ? () => ref
                              .read(decimalPrecisionProvider.notifier)
                              .setPrecision(decimalPrecision + 1)
                          : null,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.rounded_corner),
                title: const Text('Rounding Mode'),
                subtitle: Text(_getRoundingModeName(roundingMode)),
                trailing: DropdownButton<String>(
                  value: roundingMode,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: 'up', child: Text('Up')),
                    DropdownMenuItem(value: 'down', child: Text('Down')),
                    DropdownMenuItem(value: 'halfUp', child: Text('Half Up')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(roundingModeProvider.notifier)
                          .setRoundingMode(value);
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            'Security',
            [
              SwitchListTile(
                secondary: const Icon(Icons.fingerprint),
                title: const Text('Biometric Lock'),
                subtitle: const Text('Require authentication on app open'),
                value: biometricEnabled,
                onChanged: _toggleBiometric,
              ),
            ],
          ),
          _buildSection(
            context,
            'Data',
            [
              ListTile(
                leading: const Icon(Icons.delete_sweep),
                title: const Text('Clear Cache'),
                subtitle: const Text('Remove all cached data'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Cache'),
                      content: const Text(
                        'This will remove all cached exchange rates and historical data. Are you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(settingsRepositoryProvider).clearAllData();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cache cleared')),
                            );
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            'About',
            [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share App'),
                onTap: () {
                  Share.share(
                    'Check out Currency Converter Pro - Live Rates!\nThe best currency converter app with offline support.',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Rate App'),
                onTap: () {
                  // Open store listing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thank you for your support!'),
                    ),
                  );
                },
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Hire Me'),
                subtitle: const Text('Available for freelance projects'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hire Me'),
                      content: const Text(
                        'I\'m available for Flutter development projects.\n\nEmail: developer@example.com\nGitHub: github.com/developer',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  String _getRoundingModeName(String mode) {
    switch (mode) {
      case 'up':
        return 'Round Up';
      case 'down':
        return 'Round Down';
      case 'halfUp':
      default:
        return 'Round Half Up';
    }
  }
}
