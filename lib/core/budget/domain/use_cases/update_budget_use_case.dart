import 'package:linum/core/budget/domain/enums/budget_change_mode.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/domain/use_cases/update_time_span_use_case.dart';



abstract class UpdateBudgetUseCase {
  Future<void> execute(Budget old, Budget update, DateTime? selectedDate, BudgetChangeMode changeMode);
}

class UpdateBudgetUseCaseImpl implements UpdateBudgetUseCase {
  final UpdateTimeSpanUseCase<Budget> _updateTimeSpanUseCase;
  final IBudgetRepository _repository;

  UpdateBudgetUseCaseImpl({
    required IBudgetRepository repository,
  }): _updateTimeSpanUseCase = UpdateTimeSpanUseCase(), _repository = repository;


  @override
  Future<void> execute(Budget old, Budget update, DateTime? selectedDate, BudgetChangeMode changeMode) async {
    final changes = await _updateTimeSpanUseCase.execute(old, update, selectedDate, changeMode);
    return _repository.executeBudgetChanges(changes);
  }
}
