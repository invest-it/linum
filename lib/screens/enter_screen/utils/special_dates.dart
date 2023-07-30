class SpecialDates {
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime tomorrow() {
    final today = SpecialDates.today();
    return DateTime(today.year, today.month, today.day + 1);
  }

  static DateTime yesterday() {
    final today = SpecialDates.today();
    return DateTime(today.year, today.month, today.day - 1);
  }
}
