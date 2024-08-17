import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

abstract class IBudgetService {
  Future<List<Budget>> getBudgetsForDate(DateTime date);
  Future<Budget> createBudget(Budget budget);
  Future<void> updateBudget(Budget old, Budget update, DateTime selectedDate, BudgetChangeMode changeMode);
  Future<void> deleteBudget(Budget budget, DateTime selectedDate, BudgetChangeMode changeMode);

  Future<MainBudget?> getMainBudgetForDate(DateTime date);
  Future<MainBudget> createMainBudget(MainBudget budget);
  Future<void> updateMainBudget(MainBudget old, MainBudget update, DateTime selectedDate, BudgetChangeMode changeMode);
  Future<void> deleteMainBudget(MainBudget budget, DateTime selectedDate, BudgetChangeMode changeMode);
}
