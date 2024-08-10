import 'package:jiffy/jiffy.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

class UpdateTimeSpanUseCase<T extends TimeSpan<T>> {
  final void Function(T value) _updateSpan;
  final void Function(T value) _createSpan;
  
  UpdateTimeSpanUseCase({
    required void Function(T) createSpan,
    required void Function(T) updateSpan,
  }) : _createSpan = createSpan, _updateSpan = updateSpan;

  void execute(T old, T update, DateTime selectedDate, BudgetChangeMode changeMode) {
    switch (changeMode) {
      case BudgetChangeMode.all:
        changeAll(update);
      case BudgetChangeMode.onlyOne:
        changeOnlyOne(old, update, selectedDate);
      case BudgetChangeMode.thisAndAllAfter:
        changeThisAndAllAfter(old, update, selectedDate);
      case BudgetChangeMode.thisAndAllBefore:
        changeThisAndAllBefore(old, update, selectedDate);
    }
  }
  
  void changeThisAndAllAfter(T old, T update, DateTime selectedDate) {
    // This and all after
    _createSpan(
      update.copySpanWith(
        start: selectedDate,
      ),
    );
    
    // Before
    _updateSpan(
      old.copySpanWith(
        end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
      ),
    );
  }
  
  void changeThisAndAllBefore(T old, T update, DateTime selectedDate) {
    _updateSpan(
      update.copySpanWith(
        end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
      ),
    );
    
    _createSpan(
      old.copySpanWith(
        start: selectedDate,
      ),
    );
  }
  
  void changeAll(T update) {
    _updateSpan(
      update,
    );
  }
  
  void changeOnlyOne(T old, T update, DateTime selectedDate) {
    // Before
    _updateSpan(
      old.copySpanWith(
        end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
      ),
    );

    _createSpan(
      update.copySpanWith(
        start: selectedDate,
        end: selectedDate,
      ),
    );

    // After
    _createSpan(
      old.copySpanWith(
        start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
      ),
    );
  }
}
