import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/domain/use_cases/update_time_span_use_case.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';



abstract class UpdateBudgetUseCase {
  Future<void> execute(Budget old, Budget update, DateTime selectedDate, BudgetChangeMode changeMode);
}

class UpdateBudgetUseCaseImpl implements UpdateBudgetUseCase {
  final UpdateTimeSpanUseCase<Budget> updateTimeSpanUseCase;

  UpdateBudgetUseCaseImpl({
    required IBudgetRepository repository,
  }): updateTimeSpanUseCase = UpdateTimeSpanUseCase(
      createSpan: repository.createBudget, updateSpan: repository.updateBudget,
  );

  @override
  Future<void> execute(Budget old, Budget update, DateTime selectedDate, BudgetChangeMode changeMode) async {
    return updateTimeSpanUseCase.execute(old, update, selectedDate, changeMode);
  }
}
