import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/domain/use_cases/update_time_span_use_case.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

abstract class UpdateMainBudgetUseCase {
  void execute(MainBudget old, MainBudget update, DateTime selectedDate, BudgetChangeMode changeMode);
}

class UpdateMainBudgetUseCaseImpl implements UpdateMainBudgetUseCase {
  final IBudgetRepository repository;
  final UpdateTimeSpanUseCase<MainBudget> updateTimeSpanUseCase;

  UpdateMainBudgetUseCaseImpl({
    required this.repository,
  }): updateTimeSpanUseCase = UpdateTimeSpanUseCase(
    createSpan: repository.createMainBudget, updateSpan: repository.updateMainBudget,
  );

  @override
  void execute(MainBudget old, MainBudget update, DateTime selectedDate, BudgetChangeMode changeMode) {
    updateTimeSpanUseCase.execute(old, update, selectedDate, changeMode);
  }
}