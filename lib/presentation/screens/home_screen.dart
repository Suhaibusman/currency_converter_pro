import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/currency_card.dart';
import '../widgets/currency_selector.dart';
import 'calculator_screen.dart';
import 'historical_screen.dart';
import 'alerts_screen.dart';
import 'settings_screen.dart';
import 'heatmap_screen.dart';
import 'insights_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _amountController = TextEditingController(text: '1');
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    final value = double.tryParse(_amountController.text);
    if (value != null) {
      ref.read(amountProvider.notifier).state = value;
    }
  }

  Future<void> _refreshRates() async {
    ref.invalidate(currencyRatesProvider);
  }

  void _showCurrencySelector(BuildContext context, bool isBase) async {
    final recentSearches = await ref.read(recentSearchesProvider.future);
    
    if (!context.mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencySelector(
        selectedCurrency: isBase
            ? ref.read(baseCurrencyProvider)
            : ref.read(selectedCurrenciesProvider).first,
        onCurrencySelected: (currency) {
          if (isBase) {
            ref.read(baseCurrencyProvider.notifier).state = currency;
          }
          ref.read(currencyRepositoryProvider).addRecentSearch(currency);
        },
        recentSearches: recentSearches,
        onSearch: (currency) {
          ref.read(currencyRepositoryProvider).addRecentSearch(currency);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeContent(),
      const CalculatorScreen(),
      const HistoricalScreen(),
      const HeatmapScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: const Text('Currency Converter Pro'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AlertsScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.insights_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InsightsScreen(),
                      ),
                    );
                  },
                ),
              ],
            )
          : null,
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.currency_exchange_outlined),
            selectedIcon: Icon(Icons.currency_exchange),
            label: 'Convert',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Heatmap',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    final ratesAsync = ref.watch(currencyRatesProvider);
    final baseCurrency = ref.watch(baseCurrencyProvider);
    final selectedCurrencies = ref.watch(selectedCurrenciesProvider);
    final amount = ref.watch(amountProvider);
    final decimalPrecision = ref.watch(decimalPrecisionProvider);
    final networkStatus = ref.watch(networkStatusProvider);

    return RefreshIndicator(
      onRefresh: _refreshRates,
      child: Column(
        children: [
          // Network Status Banner
          networkStatus.when(
            data: (isConnected) {
              if (!isConnected) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange,
                  child: const Text(
                    'Offline Mode - Using cached data',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          // Amount Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _showCurrencySelector(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          baseCurrency,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Conversion Results
          Expanded(
            child: ratesAsync.when(
              data: (rates) {
                return ListView.builder(
                  itemCount: selectedCurrencies.length,
                  itemBuilder: (context, index) {
                    final currency = selectedCurrencies[index];
                    final rate = rates.getRate(currency) ?? 1.0;

                    return CurrencyCard(
                      currency: currency,
                      rate: rate,
                      amount: amount,
                      isBase: currency == baseCurrency,
                      decimalPrecision: decimalPrecision,
                      onTap: () {
                        // Switch to this currency as base
                        ref.read(baseCurrencyProvider.notifier).state = currency;
                      },
                    );
                  },
                );
              },
              loading: () => const LoadingWidget(
                message: 'Loading exchange rates...',
              ),
              error: (error, stack) => ErrorWidget(
                message: error.toString(),
                onRetry: _refreshRates,
              ),
            ),
          ),
        ],
      ),
    );
  }
}