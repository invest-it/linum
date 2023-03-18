extension DateTimeExtension on DateTime {
  /// returns a if a isAfter this, return this else
  DateTime returnLaterDate(DateTime a) {
    if (a.isAfter(this)) {
      return a;
    } else {
      return this;
    }
  }
}
