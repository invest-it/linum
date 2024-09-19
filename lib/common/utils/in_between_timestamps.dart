//  Extension-Functions for handling timestamps
//
//  Author: damattl
//


import 'package:tuple/tuple.dart';

Tuple2<DateTime, DateTime> timestampsFromNow() {
  return Tuple2(
    DateTime(
      DateTime.now().year,
      DateTime.now().month,
    ).subtract(const Duration(microseconds: 1)),
    DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    ),
  );
}

Tuple2<DateTime, DateTime> timestampsFromCurrentShownDate(DateTime date) {
  return Tuple2(
    date.subtract(const Duration(microseconds: 1)),
    DateTime(
      date.year,
      date.month + 1,
    ),
  );
}
