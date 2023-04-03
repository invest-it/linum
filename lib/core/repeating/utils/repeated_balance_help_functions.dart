//  Repeated Balance Helper Functions - Utility Functions that facilitate the editing and deletion process of repeated Transactions
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:linum/core/balance/models/serial_transaction.dart';

bool isMonthly(SerialTransaction serialTransaction) {
  return serialTransaction.repeatDurationType.name.toUpperCase() ==
          "MONTHS";
}

/// after splitting a repeatable delete copied "changes" attributes that are out of the time limits of that repeatable
void removeUnusedChangedAttributes(
  SerialTransaction serialTransaction,
) {
  if (serialTransaction.changed == null || serialTransaction.endDate == null) {
    return;
  }
  final List<String> keysToRemove = <String>[];
  for (final timeStampString in serialTransaction.changed!.keys) {
    if (!DateTime.fromMillisecondsSinceEpoch(
          (num.tryParse(timeStampString) as int?) ?? 0,
        ).isBefore(
          serialTransaction.startDate.toDate(),
        ) &&
        !DateTime.fromMillisecondsSinceEpoch(
          (num.tryParse(timeStampString) as int?) ?? 0,
        ).isAfter(
          serialTransaction.endDate!.toDate(),
        )) {
      keysToRemove.add(timeStampString);
    }
  }
  for (final key in keysToRemove) {
    serialTransaction.changed!.remove(key);
  }
}


Timestamp? changeThisAndAllAfterEndTimeHelpFunction(
    Timestamp? checkedEndTime,
    SerialTransaction oldSerialTransaction,
    Duration timeDifference,
) {
  if (checkedEndTime != null) {
    return checkedEndTime;
  }
  if (oldSerialTransaction.endDate != null) {
    return Timestamp.fromDate(
      oldSerialTransaction.endDate!
          .toDate()
          .subtract(timeDifference),
    );
  } else {
    return null;
  }
}
