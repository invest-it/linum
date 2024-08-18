import 'package:jiffy/jiffy.dart';
import 'package:linum/core/budget/domain/models/changes.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

class DeleteTimeSpanUseCase<T extends TimeSpan<T>> {
  DeleteTimeSpanUseCase();

  Future<List<ModelChange<T>>> execute(T item, DateTime? selectedDate, BudgetChangeMode changeMode) async {
    assert(selectedDate != null || changeMode == BudgetChangeMode.all);

    switch (changeMode) {
      case BudgetChangeMode.all:
        return deleteAll(item);
      case BudgetChangeMode.onlyOne:
        return deleteOnlyOne(item, selectedDate!);
      case BudgetChangeMode.thisAndAllAfter:
        return deleteThisAndAllAfter(item, selectedDate!);
      case BudgetChangeMode.thisAndAllBefore:
        return deleteThisAndAllBefore(item, selectedDate!);
    }
  }

  // TODO: Decide on how to handle await
  Future<List<ModelChange<T>>> deleteThisAndAllAfter(T item, DateTime selectedDate) async {
    if (!item.containsDate(selectedDate)) {
      throw Exception("Date is outside of TimeSpans range");
    }

    return [
      // All before deletion date
      ModelChange(
        ChangeType.create,
        item.copySpanWith(
          id: TimeSpan.newId(),
          end:  Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
        ),
      ),

      // This and all after
      ModelChange(
        ChangeType.delete,
        item,
      ),
    ];
  }

  Future<List<ModelChange<T>>> deleteThisAndAllBefore(T item, DateTime selectedDate) async {
    if (!item.containsDate(selectedDate)) {
      throw Exception("Date is outside of TimeSpans range");
    }

    return [
      // All after deletion date
      ModelChange(
        ChangeType.create,
        item.copySpanWith(
          id: TimeSpan.newId(),
          start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
        ),
      ),

      // This and all before
      ModelChange(
        ChangeType.delete,
        item,
      ),
    ];
  }

  Future<List<ModelChange<T>>> deleteAll(T item) async {
    return [
      // All
      ModelChange(
        ChangeType.delete,
        item,
      ),
    ];
  }

  Future<List<ModelChange<T>>> deleteOnlyOne(T item, DateTime selectedDate) async {
    if (!item.containsDate(selectedDate)) {
      throw Exception("Date is outside of TimeSpans range");
    }

    return [
      // Before deletion start date
      ModelChange(
        ChangeType.create,
        item.copySpanWith(
          id: TimeSpan.newId(),
          end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
        ),
      ),
      // Selected Date
      ModelChange(
        ChangeType.delete,
        item,
      ),
      // After deletion end date
      ModelChange(
        ChangeType.create,
        item.copySpanWith(
          id: TimeSpan.newId(),
          start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
        ),
      ),
    ];
  }
}
