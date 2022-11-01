//  Repeated Balance Data Remover - augments the StreamBuilder Manager with repeatable-specific Elements
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/changed_repeated_balance.dart';
import 'package:linum/types/date_time_map.dart';

class RepeatedBalanceDataRemover {
  static bool removeAll(BalanceDocument data, String id) {
    final int length = data.repeatedBalance.length;
    data.repeatedBalance.removeWhere((element) {
      return element.id == id;
    });
    if (length == data.repeatedBalance.length) {
      dev.log("The repeatable balance wasn't found"); // ???
      return false;
    }
    return true;
  }

  static bool removeThisAndAllBefore(
    BalanceDocument data,
    String id,
    Timestamp time,
  ) {
    final singleRepeatedBalance = data.repeatedBalance.firstWhereOrNull((element) => element.id == id);
    if (singleRepeatedBalance == null) {
      return false;
    }

    if (singleRepeatedBalance.repeatDurationType.toString().toUpperCase() == "MONTHS") {
      singleRepeatedBalance.initialTime = Timestamp.fromDate(
        DateTime(
          time.toDate().year,
          time.toDate().month +
              singleRepeatedBalance.repeatDuration,
          time.toDate().day,
        ),
      );
    } else {
      // if not month => seconds
      singleRepeatedBalance.initialTime = Timestamp.fromDate(
        time.toDate().add(
          Duration(
            seconds: singleRepeatedBalance.repeatDuration,
          ),
        ),
      );
    }

    return true;
  }

  static bool removeThisAndAllAfter(
    BalanceDocument data,
    String id,
    Timestamp time,
  ) {
    final singleRepeatedBalance = data.repeatedBalance.firstWhereOrNull((element) => element.id == id);
    if (singleRepeatedBalance == null) {
      return false;
    }

    if (singleRepeatedBalance.repeatDurationType.toString().toUpperCase() == "MONTHS") {
      singleRepeatedBalance.endTime = Timestamp.fromDate(
        DateTime(
          time.toDate().year,
          time.toDate().month - singleRepeatedBalance.repeatDuration,
          time.toDate().day,
        ),
      );
    } else {
      // if not month => seconds
      singleRepeatedBalance.endTime = Timestamp.fromDate(
        time.toDate().subtract(
          Duration(
            seconds: singleRepeatedBalance.repeatDuration,
          ),
        ),
      );
    }
    return true;
  }

  static bool removeOnlyThisOne(
    BalanceDocument data,
    String id,
    Timestamp time,
  ) {
    final singleRepeatedBalance = data.repeatedBalance.firstWhereOrNull((element) => element.id == id);
    if (singleRepeatedBalance == null) {
      return false;
    }

    singleRepeatedBalance.changed ??= DateTimeMap();

    singleRepeatedBalance.changed!.addAll({
      time.millisecondsSinceEpoch.toString(): ChangedRepeatedBalanceData(deleted: true)
    });

    return true;
  }
}
