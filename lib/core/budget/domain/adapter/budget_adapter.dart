import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';

abstract class IBudgetAdapter {
  Future<List<Budget>> getBudgetsForDate(DateTime date);
  Future<void> createBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(String id);

  Future<MainBudget?> getMainBudgetForDate(DateTime date);
  Future<void> createMainBudget(MainBudget budget);
  Future<void> updateMainBudget(MainBudget budget);
  Future<void> deleteMainBudget(String id);
}
