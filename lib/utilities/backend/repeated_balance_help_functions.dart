//  Repeated Balance Helper Functions - Utility Functions that facilitate the editing and deletion process of repeated Transactions
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:linum/models/serial_transaction.dart';

bool isMonthly(SerialTransaction serialTransaction) {
  return serialTransaction.repeatDurationType.name.toUpperCase() ==
          "MONTHS";
}

/// after splitting a repeatable delete copied "changes" attributes that are out of the time limits of that repeatable
void removeUnusedChangedAttributes(
  SerialTransaction serialTransaction,
) {
  if (serialTransaction.changed == null || serialTransaction.endTime == null) {
    return;
  }
  final List<String> keysToRemove = <String>[];
  for (final timeStampString in serialTransaction.changed!.keys) {
    if (!DateTime.fromMillisecondsSinceEpoch(
          (num.tryParse(timeStampString) as int?) ?? 0,
        ).isBefore(
          serialTransaction.initialTime.toDate(),
        ) &&
        !DateTime.fromMillisecondsSinceEpoch(
          (num.tryParse(timeStampString) as int?) ?? 0,
        ).isAfter(
          serialTransaction.endTime!.toDate(),
        )) {
      keysToRemove.add(timeStampString);
    }
  }
  for (final key in keysToRemove) {
    serialTransaction.changed!.remove(key);
  }
}


firestore.Timestamp? changeThisAndAllAfterEndTimeHelpFunction(
    firestore.Timestamp? checkedEndTime,
    SerialTransaction oldSerialTransaction,
    Duration timeDifference,
) {
  if (checkedEndTime != null) {
    return checkedEndTime;
  }
  if (oldSerialTransaction.endTime != null) {
    return firestore.Timestamp.fromDate(
      oldSerialTransaction.endTime!
          .toDate()
          .subtract(timeDifference),
    );
  } else {
    return null;
  }
}
