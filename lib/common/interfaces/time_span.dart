import 'package:uuid/uuid.dart';

abstract class TimeSpan<T> {
  T copySpanWith({
    DateTime? start,
    DateTime? end,
    String? id,
  });

  String getId();
  static String newId() => const Uuid().v4();

  DateTime getStart();
  DateTime? getEnd();
}

int timeSpanComparer<T>(TimeSpan<T> a, TimeSpan<T> b) {
  if (a.getEnd() == null) {
    return 1;
  }
  if (b.getEnd() == null) {
    return -1;
  }

  return a.getEnd()!.compareTo(b.getEnd()!);
}

extension TimeSpanUtils<T> on TimeSpan<T> {
  bool containsDate(DateTime date) {
    final start = getStart();
    final end = getEnd();

    final dateSanitized = DateTime(date.year, date.month);
    final startSanitized = DateTime(start.year, start.month);

    if (dateSanitized.isBefore(startSanitized)) {
      return false;
    }

    if (end == null) {
      return true;
    }

    final endSanitized = DateTime(end.year, end.month);
    if (dateSanitized.isAfter(endSanitized)) {
      return false;
    }

    return true;
  }
}
