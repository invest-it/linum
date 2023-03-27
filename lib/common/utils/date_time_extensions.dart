extension DateTimeExtensions on DateTime {
  bool isInFuture() {
    final now = DateTime.now();
    return isAfter(
      DateTime(
        now.year,
        now.month,
        now.day + 1,
      ).subtract(const Duration(microseconds: 1)),
    );
  }

  bool isCurrentMonth() {
    final now = DateTime.now();
    return DateTime(year, month) ==
        DateTime(now.year, now.month);
  }

  DateTime dayBefore() {
    return DateTime(
      year, month, day,
    ).subtract(const Duration(days: 1, microseconds: 1));
  }


}
