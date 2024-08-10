import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

abstract class DeleteBudgetUseCase {
  void execute(Budget budget, DateTime selectedDate, BudgetChangeMode changeMode);
}

class DeleteBudgetUseCaseImpl implements DeleteBudgetUseCase {
  @override
  void execute(Budget budget, DateTime selectedDate, BudgetChangeMode changeMode) {
    // Use your own implementation of DeleteTimeSpanUseCase
    // TODO: implement execute
  }
}