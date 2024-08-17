import 'package:jiffy/jiffy.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

class UpdateTimeSpanUseCase<T extends TimeSpan<T>> {
  final Future<void> Function(T value) _updateSpan;
  final Future<void> Function(T value) _createSpan;
  
  UpdateTimeSpanUseCase({
    required Future<void> Function(T) createSpan,
    required Future<void> Function(T) updateSpan,
  }) : _createSpan = createSpan, _updateSpan = updateSpan;

  Future<void> execute(T old, T update, DateTime selectedDate, BudgetChangeMode changeMode) async {
    switch (changeMode) {
      case BudgetChangeMode.all:
        await changeAll(update);
      case BudgetChangeMode.onlyOne:
        await changeOnlyOne(old, update, selectedDate);
      case BudgetChangeMode.thisAndAllAfter:
        await changeThisAndAllAfter(old, update, selectedDate);
      case BudgetChangeMode.thisAndAllBefore:
        await changeThisAndAllBefore(old, update, selectedDate);
    }
  }

  // TODO: Decide on how to handle await
  Future<void> changeThisAndAllAfter(T old, T update, DateTime selectedDate) async {
    // This and all after
    await _createSpan(
      update.copySpanWith(
        start: selectedDate,
        id: TimeSpan.newId(),
      ),
    );
    
    // Before
    await _updateSpan(
      old.copySpanWith(
        end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
      ),
    );
  }
  
  Future<void> changeThisAndAllBefore(T old, T update, DateTime selectedDate) async {
    await _updateSpan(
      update.copySpanWith(
        end: Jiffy.parseFromDateTime(selectedDate).dateTime,
      ),
    );
    
    await _createSpan(
      old.copySpanWith(
        id: TimeSpan.newId(),
        start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
      ),
    );
  }
  
  Future<void> changeAll(T update) async {
    await _updateSpan(
      update,
    );
  }
  
  Future<void> changeOnlyOne(T old, T update, DateTime selectedDate) async {
    // Before
    await _updateSpan(
      old.copySpanWith(
        end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
      ),
    );

    await _createSpan(
      update.copySpanWith(
        id: TimeSpan.newId(),
        start: selectedDate,
        end: selectedDate,
      ),
    );

    // After
    await _createSpan(
      old.copySpanWith(
        id: TimeSpan.newId(),
        start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
      ),
    );
  }
}
