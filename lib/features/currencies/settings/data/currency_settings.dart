import 'package:linum/features/currencies/core/data/models/currency.dart';

class CurrencySettings {
  final Currency currency;

  CurrencySettings({
    required this.currency,
  });

  CurrencySettings copyWith({
    Currency? currency,
  }) {
    return CurrencySettings(
      currency: currency ?? this.currency,
    );
  }

  @override
  String toString() => 'CurrencySettings(currency: $currency)';
}
