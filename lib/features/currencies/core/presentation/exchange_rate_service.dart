import 'package:flutter/cupertino.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';

abstract class IExchangeRateService with ChangeNotifier {
  Currency get standardCurrency;
  Future addExchangeRatesToTransactions(List<Transaction> transactions);
}
