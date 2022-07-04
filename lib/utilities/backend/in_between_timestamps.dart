import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

Tuple2<Timestamp, Timestamp> timestampsFromNow() {
  return Tuple2(
    Timestamp.fromDate(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
      ).subtract(const Duration(microseconds: 1)),
    ),
    Timestamp.fromDate(
      DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
      ),
    ),
  );
}

Tuple2<Timestamp, Timestamp> timestampsFromCurrentShownDate(DateTime date) {
  return Tuple2(
    Timestamp.fromDate(
      date.subtract(const Duration(microseconds: 1)),
    ),
    Timestamp.fromDate(
      DateTime(
        date.year,
        date.month + 1,
      ),
    ),
  );
}
