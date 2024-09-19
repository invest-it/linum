import 'package:jiffy/jiffy.dart';
import 'package:linum/common/interfaces/time_span.dart';
import 'package:linum/core/budget/domain/models/changes.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

class UpdateTimeSpanUseCase<T extends TimeSpan<T>> {

  UpdateTimeSpanUseCase();

  Future<List<ModelChange<T>>> execute(T old, T update, DateTime? selectedDate, BudgetChangeMode changeMode) async {
    assert(selectedDate != null || changeMode == BudgetChangeMode.all);

    switch (changeMode) {
      case BudgetChangeMode.all:
        return changeAll(update);
      case BudgetChangeMode.onlyOne:
        return changeOnlyOne(old, update, selectedDate!);
      case BudgetChangeMode.thisAndAllAfter:
        return changeThisAndAllAfter(old, update, selectedDate!);
      case BudgetChangeMode.thisAndAllBefore:
        return changeThisAndAllBefore(old, update, selectedDate!);
    }
  }

  // TODO: Decide on how to handle await
  Future<List<ModelChange<T>>> changeThisAndAllAfter(T old, T update, DateTime selectedDate) async {
    if (!old.containsDate(selectedDate)) {
      throw Exception("Date is outside of TimeSpans range");
    }

    return [
      // This and all after
      ModelChange(
        ChangeType.create,
        update.copySpanWith(
          start: selectedDate,
          id: TimeSpan.newId(),
        ),
      ),

      // Before
      ModelChange(
        ChangeType.update,
        old.copySpanWith(
          end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
        ),
      ),
    ];
  }
  
  Future<List<ModelChange<T>>> changeThisAndAllBefore(T old, T update, DateTime selectedDate) async {
    if (!old.containsDate(selectedDate)) {
      throw Exception("Date is outside of TimeSpans range");
    }

    return [
      // This and all after
      ModelChange(
        ChangeType.update,
        update.copySpanWith(
          end: Jiffy.parseFromDateTime(selectedDate).dateTime,
        ),
      ),

      // Before
      ModelChange(
        ChangeType.create,
        old.copySpanWith(
          id: TimeSpan.newId(),
          start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
        ),
      ),
    ];

  }
  
  Future<List<ModelChange<T>>> changeAll(T update) async {
    return [
      ModelChange(ChangeType.update, update),
    ];
  }
  
  Future<List<ModelChange<T>>> changeOnlyOne(T old, T update, DateTime selectedDate) async {
    if (!old.containsDate(selectedDate)) {
      throw Exception("Date is outside of TimeSpans range");
    }

    return [
      // Before
      ModelChange(
        ChangeType.update,
        old.copySpanWith(
          end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
        ),
      ),

      ModelChange(
        ChangeType.create,
        update.copySpanWith(
          id: TimeSpan.newId(),
          start: selectedDate,
          end: selectedDate,
        ),
      ),

      // After
      ModelChange(
        ChangeType.create,
        old.copySpanWith(
          id: TimeSpan.newId(),
          start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
        ),
      ),
    ];
  }
}
