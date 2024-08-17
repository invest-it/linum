import 'package:jiffy/jiffy.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

class DeleteTimeSpanUseCase<T extends TimeSpan<T>> {
  final Future<void> Function(T value) _deleteSpan;
  final Future<void> Function(T value) _createSpan;

  DeleteTimeSpanUseCase({
    required Future<void> Function(T) createSpan,
    required Future<void> Function(T) deleteSpan,
  }) : _createSpan = createSpan, _deleteSpan = deleteSpan;

  Future<void> execute(T item, DateTime selectedDate, BudgetChangeMode changeMode) async {
    switch (changeMode) {
      case BudgetChangeMode.all:
        await deleteAll(item);
      case BudgetChangeMode.onlyOne:
        await deleteOnlyOne(item, selectedDate);
      case BudgetChangeMode.thisAndAllAfter:
        await deleteThisAndAllAfter(item, selectedDate);
      case BudgetChangeMode.thisAndAllBefore:
        await deleteThisAndAllBefore(item, selectedDate);
    }
  }

  // TODO: Decide on how to handle await
  Future<void> deleteThisAndAllAfter(T item, DateTime selectedDate) async {
    // All before deletion date
    await _createSpan(
      item.copySpanWith(
        id: TimeSpan.newId(),
        end:  Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
      ),
    );

    // This and all after
    await _deleteSpan(
      item,
    );
  }

  Future<void> deleteThisAndAllBefore(T item, DateTime selectedDate) async {
    // All after deletion date
    await _createSpan(
      item.copySpanWith(
        id: TimeSpan.newId(),
        start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
      ),
    );

    //This and all before
    await _deleteSpan(
      item,
    );
  }

  Future<void> deleteAll(T item) async {
    //All
    await _deleteSpan(
      item,
    );
  }

  Future<void> deleteOnlyOne(T item, DateTime selectedDate) async {
    // Before deletion start date
    await _createSpan(
      item.copySpanWith(
        id: TimeSpan.newId(),
        end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
      ),
    );

    // Selected Date
    await _deleteSpan(
      item,
    );

    // After deletion end date
    await _createSpan(
      item.copySpanWith(
        id: TimeSpan.newId(),
        start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
      ),
    );
  }
}
