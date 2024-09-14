
abstract class IBudgetStatisticsService {
  Future<num> getExpensesForCategory(String category, DateTime month);
  Future<num> getIncomeForMonth(DateTime month);
}

