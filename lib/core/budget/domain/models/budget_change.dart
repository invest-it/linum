import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';

enum ChangeType {
  create,
  update,
  delete,
}

class BudgetChange {
  final ChangeType type;
  final Budget budget;

  BudgetChange(this.type, this.budget);
}

class MainBudgetChange {
  final ChangeType type;
  final MainBudget mainBudget;

  MainBudgetChange(this.type, this.mainBudget);
}
