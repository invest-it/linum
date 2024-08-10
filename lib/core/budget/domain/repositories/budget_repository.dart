import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';

// The repository should never be used directly, only through use cases
abstract class IBudgetRepository {
  // TODO: Document possible exceptions
  Budget createBudget(Budget budget);

  // TODO: Document possible exceptions
  MainBudget createMainBudget(MainBudget budget);

  // TODO: Document possible exceptions
  void updateBudget(Budget budget);

  // TODO: Document possible exceptions
  void updateMainBudget(MainBudget budget);

  // TODO: Document possible exceptions
  void removeBudget(Budget budget);

  // TODO: Document possible exceptions
  void removeMainBudget(MainBudget budget);


}
