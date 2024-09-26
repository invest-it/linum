import 'package:linum/core/budget/domain/enums/budget_change_mode.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/domain/use_cases/update_time_span_use_case.dart';

abstract class UpdateMainBudgetUseCase {
  Future<void> execute(MainBudget old, MainBudget update, DateTime selectedDate, BudgetChangeMode changeMode);
}

class UpdateMainBudgetUseCaseImpl implements UpdateMainBudgetUseCase {
  final IBudgetRepository _repository;
  final UpdateTimeSpanUseCase<MainBudget> _updateTimeSpanUseCase;

  UpdateMainBudgetUseCaseImpl({
    required IBudgetRepository repository,
  }): _updateTimeSpanUseCase = UpdateTimeSpanUseCase(), _repository = repository;

  @override
  Future<void> execute(MainBudget old, MainBudget update, DateTime selectedDate, BudgetChangeMode changeMode) async {
    final changes = await _updateTimeSpanUseCase.execute(old, update, selectedDate, changeMode);
    return _repository.executeMainBudgetChanges(changes);
  }
}
