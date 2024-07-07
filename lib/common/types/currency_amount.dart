// TODO: Maybe move this to balance
// TODO: Maybe this is not even needed

import 'package:linum/features/currencies/core/data/models/currency.dart';

class CurrencyAmount {
  final double amount;
  final Currency currency;

  CurrencyAmount({required this.amount, required this.currency});
}
