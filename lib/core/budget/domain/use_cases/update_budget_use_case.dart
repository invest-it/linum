import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/domain/use_cases/update_time_span_use_case.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';



abstract class UpdateBudgetUseCase {
  void execute(Budget old, Budget update, DateTime selectedDate, BudgetChangeMode changeMode);
}

class UpdateBudgetUseCaseImpl implements UpdateBudgetUseCase {
  final UpdateTimeSpanUseCase<Budget> updateTimeSpanUseCase;

  UpdateBudgetUseCaseImpl({
    required IBudgetRepository repository,
  }): updateTimeSpanUseCase = UpdateTimeSpanUseCase(
      createSpan: repository.createBudget, updateSpan: repository.updateBudget,
  );

  @override
  void execute(Budget old, Budget update, DateTime selectedDate, BudgetChangeMode changeMode) {
    updateTimeSpanUseCase.execute(old, update, selectedDate, changeMode);
  }
}

