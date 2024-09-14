import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/budget/presentation/budget_statistics_service.dart';

class BudgetStatisticsService implements IBudgetStatisticsService {
  final IBalanceDataService _balanceDataService;

  BudgetStatisticsService({
    required IBalanceDataService balanceDataService,
  }) : _balanceDataService = balanceDataService;

  @override
  Future<num> getIncomeForMonth(DateTime month) async {
    final transactions = await _balanceDataService.getTransactionsForMonth(month);

    // TODO: Handle different Currencies
    num income = 0;
    for (final s in transactions) {
      if (!s.isIncome()) {
        continue;
      }
      if (s.repeatId == null) { // If transaction is serialTransaction
        continue;
      }

      income += s.amountInStandardCurrency;
    }
    return income;
  }


  @override
  Future<num> getExpensesForCategory(String category, DateTime month) async {
    final transactions = await _balanceDataService.getTransactionsForMonth(month);

    num expenses = 0;
    for (final t in transactions) {
      if (t.isIncome()) {
        continue;
      }
      if (t.category != category) {
        continue;
      }
      expenses += t.amountInStandardCurrency;
    }
    return expenses;
  }



}