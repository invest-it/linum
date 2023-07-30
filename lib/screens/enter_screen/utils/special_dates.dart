class SpecialDates {
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime tomorrow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  static DateTime dayAfterTomorrow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 2);
  }

  static DateTime yesterday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - 1);
  }
}
