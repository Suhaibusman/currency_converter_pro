import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/number_formatter.dart';

class CurrencyCard extends StatelessWidget {
  final String currency;
  final double rate;
  final double? amount;
  final bool isBase;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final int decimalPrecision;

  const CurrencyCard({
    super.key,
    required this.currency,
    required this.rate,
    this.amount,
    this.isBase = false,
    this.onTap,
    this.onLongPress,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.decimalPrecision = 4,
  });

  @override
  Widget build(BuildContext context) {
    final convertedAmount = amount != null ? amount! * rate : rate;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress?.call();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isBase
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  AppConstants.currencySymbols[currency] ?? currency[0],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          currency,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (isBase) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'BASE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      AppConstants.currencyNames[currency] ?? currency,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberFormatter.formatCurrency(
                      convertedAmount,
                      decimalPlaces: decimalPrecision,
                    ),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Rate: ${NumberFormatter.formatCurrency(rate, decimalPlaces: 6)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (onFavoriteToggle != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite
                        ? Colors.amber
                        : Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onFavoriteToggle!();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}