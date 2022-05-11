import 'package:cloud_firestore/cloud_firestore.dart';

bool isMonthly(Map<String, dynamic> singleRepeatedBalance) {
  return singleRepeatedBalance["repeatDurationType"] != null &&
      (singleRepeatedBalance["repeatDurationType"] as String).toUpperCase() ==
          "MONTHS";
}

/// after splitting a repeatable delete copied "changes" attributes that are out of the time limits of that repeatable
void removeUnusedChangedAttributes(
  Map<String, dynamic> singleRepeatedBalance,
) {
  if (singleRepeatedBalance["changes"] == null) {
    return;
  }
  final List<String> keysToRemove = <String>[];
  for (final timeStampString
      in (singleRepeatedBalance["changes"] as Map<String, dynamic>).keys) {
    if (!DateTime.fromMillisecondsSinceEpoch(
          (num.tryParse(timeStampString) as int?) ?? 0,
        ).isBefore(
          (singleRepeatedBalance["initialTime"] as Timestamp).toDate(),
        ) &&
        !DateTime.fromMillisecondsSinceEpoch(
          (num.tryParse(timeStampString) as int?) ?? 0,
        ).isAfter(
          (singleRepeatedBalance["endTime"] as Timestamp).toDate(),
        )) {
      keysToRemove.add(timeStampString);
    }
  }
  for (final key in keysToRemove) {
    (singleRepeatedBalance["changes"] as Map<String, dynamic>).remove(key);
  }
}

Timestamp? changeThisAndAllAfterEndTimeHelpFunction(
  Timestamp? checkedEndTime,
  Map<String, dynamic> newRepeatedBalance,
  Duration timeDifference,
) {
  if (checkedEndTime != null) {
    return checkedEndTime;
  }
  if (newRepeatedBalance["endTime"] != null) {
    return Timestamp.fromDate(
      (newRepeatedBalance["endTime"] as Timestamp)
          .toDate()
          .subtract(timeDifference),
    );
  } else {
    return null;
  }
}
