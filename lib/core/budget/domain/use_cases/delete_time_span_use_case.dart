import 'package:jiffy/jiffy.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

class DeleteTimeSpanUseCase<T extends TimeSpan<T>> {
  final void Function(T value) _deleteSpan;
  final void Function(T value) _createSpan;

  DeleteTimeSpanUseCase({
    required void Function(T) createSpan,
    required void Function(T) deleteSpan,
  }) : _createSpan = createSpan, _deleteSpan = deleteSpan;

  void execute(T item, DateTime selectedDate, BudgetChangeMode changeMode) {
    switch (changeMode) {
      case BudgetChangeMode.all:
        deleteAll(item);
      case BudgetChangeMode.onlyOne:
        deleteOnlyOne(item, selectedDate);
      case BudgetChangeMode.thisAndAllAfter:
        deleteThisAndAllAfter(item, selectedDate);
      case BudgetChangeMode.thisAndAllBefore:
        deleteThisAndAllBefore(item, selectedDate);
    }
  }

  void deleteThisAndAllAfter(T item, DateTime selectedDate) {
    // All before deletion date
    _createSpan(
      item.copySpanWith(
        end:  Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
      ),
    );

    // This and all after
    _deleteSpan(
      item,
    );
  }

  void deleteThisAndAllBefore(T item, DateTime selectedDate) {
    // All after deletion date
    _createSpan(
      item.copySpanWith(
        start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
      ),
    );

    //This and all before
    _deleteSpan(
      item,
    );
  }

  void deleteAll(T item) {
    //All
    _deleteSpan(
      item,
    );
  }

  void deleteOnlyOne(T item, DateTime selectedDate) {
    // Before deletion start date
    _createSpan(
      item.copySpanWith(
        end: Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime,
      ),
    );

    // Selected Date
    _deleteSpan(
      item,
    );

    // After deletion end date
    _createSpan(
      item.copySpanWith(
        start: Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime,
      ),
    );
  }
}
