enum TimeWidgetDate {
  none,
  future,
  today,
  yesterday,
  lastWeek,
  thisMonth;

  String toLabel() {
    switch (this) {
      case TimeWidgetDate.none:
        return 'listview.label-no-entries';
      case TimeWidgetDate.future:
        return 'listview.label-future';
      case TimeWidgetDate.today:
        return 'listview.label-today';
      case TimeWidgetDate.yesterday:
        return 'listview.label-yesterday';
      case TimeWidgetDate.lastWeek:
        return 'listview.label-lastweek';
      case TimeWidgetDate.thisMonth:
        return 'listview.label-thismonth';
    }
  }

  DateTime? toDate() {
    switch(this) {
      case TimeWidgetDate.none:
        return null;
      case TimeWidgetDate.future:
        return null;
      case TimeWidgetDate.today:
        return DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).add(const Duration(days: 1, microseconds: -1));
      case TimeWidgetDate.yesterday:
        return DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).subtract(const Duration(microseconds: 1));
      case TimeWidgetDate.lastWeek:
        return DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).subtract(const Duration(days: 1, microseconds: 1));
      case TimeWidgetDate.thisMonth:
        return DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).subtract(const Duration(days: 7, microseconds: 1));
    }
  }
}
