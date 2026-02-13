import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class CurrencySelector extends StatefulWidget {
  final String selectedCurrency;
  final Function(String) onCurrencySelected;
  final List<String>? recentSearches;
  final Function(String)? onSearch;

  const CurrencySelector({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
    this.recentSearches,
    this.onSearch,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCurrencies = AppConstants.popularCurrencies;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCurrencies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies() {
    final query = _searchController.text.toUpperCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = AppConstants.popularCurrencies;
      } else {
        _filteredCurrencies = AppConstants.popularCurrencies
            .where((currency) =>
                currency.contains(query) ||
                (AppConstants.currencyNames[currency]
                        ?.toUpperCase()
                        .contains(query) ??
                    false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search currency',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          if (widget.recentSearches != null &&
              widget.recentSearches!.isNotEmpty &&
              _searchController.text.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.recentSearches!.map((currency) {
                return Chip(
                  label: Text(currency),
                  onDeleted: null,
                  deleteIcon: null,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                );
              }).toList(),
            ),
            const Divider(height: 32),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCurrencies.length,
              itemBuilder: (context, index) {
                final currency = _filteredCurrencies[index];
                final isSelected = currency == widget.selectedCurrency;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).cardColor,
                    child: Text(
                      AppConstants.currencySymbols[currency] ?? currency[0],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    currency,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    AppConstants.currencyNames[currency] ?? currency,
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    if (widget.onSearch != null) {
                      widget.onSearch!(currency);
                    }
                    widget.onCurrencySelected(currency);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}