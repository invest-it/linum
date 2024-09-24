import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/stats/domain/models/expense_statistic.dart';
import 'package:linum/core/stats/domain/models/income_statistic.dart';
import 'package:linum/core/stats/domain/models/statistical_calculations.dart';

abstract class IStatisticsService extends IProvidableService {
  Future<StatisticalCalculations> getStatisticalCalculations();

  Future<ExpenseStatistics> getExpensesForCategory(String category, DateTime month);
  Future<IncomeStatistics> getSerialIncomeForMonth(DateTime month);
  Future<Map<String, ExpenseStatistics>> getExpensesForCategories(Set<String> categories, DateTime month);
}
