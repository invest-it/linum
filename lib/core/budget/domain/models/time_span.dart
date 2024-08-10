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