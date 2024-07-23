import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';

abstract class IExchangeRateService extends IProvidableService {
  Currency get standardCurrency;
  Future addExchangeRatesToTransactions(List<Transaction> transactions);
}
