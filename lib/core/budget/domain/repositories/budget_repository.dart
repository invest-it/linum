import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';

// The repository should never be used directly, only through use cases
abstract class IBudgetRepository {
  // TODO: Document possible exceptions
  Future<Budget> createBudget(Budget budget);

  // TODO: Document possible exceptions
  Future<MainBudget> createMainBudget(MainBudget budget);

  // TODO: Document possible exceptions
  Future<void> updateBudget(Budget budget);

  // TODO: Document possible exceptions
  Future<void> updateMainBudget(MainBudget budget);

  // TODO: Document possible exceptions
  Future<void> removeBudget(Budget budget);

  // TODO: Document possible exceptions
  Future<void> removeMainBudget(MainBudget budget);


}
