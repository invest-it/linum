//  Repeated Balance Data Remover - augments the StreamBuilder Manager with repeatable-specific Elements
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/common/utils/date_time_map.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/changed_transaction.dart';
import 'package:logger/logger.dart';

class SerialTransactionRemover {
  static final Logger logger = Logger();

  static bool removeAll(BalanceDocument data, String id) {
    final int length = data.serialTransactions.length;
    data.serialTransactions.removeWhere((element) {
      return element.id == id;
    });
    if (length == data.serialTransactions.length) {
      logger.e("The repeatable balance wasn't found"); // ???
      return false;
    }
    return true;
  }

  static bool removeThisAndAllBefore(
    BalanceDocument data,
    String id,
    Timestamp time,
  ) {
    final index =
        data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final serialTransaction = data.serialTransactions[index];

    // if not month => seconds
    var newInitialTime = Timestamp.fromDate(
      time.toDate().add(
            Duration(
              seconds: serialTransaction.repeatDuration,
            ),
          ),
    );

    if (serialTransaction.repeatDurationType.name.toUpperCase() == "MONTHS") {
      newInitialTime = Timestamp.fromDate(
        DateTime(
          time.toDate().year,
          time.toDate().month + serialTransaction.repeatDuration,
          time.toDate().day,
        ),
      );
    }

    data.serialTransactions[index] =
        serialTransaction.copyWith(initialTime: newInitialTime);

    return true;
  }

  static bool removeThisAndAllAfter(
    BalanceDocument data,
    String id,
    Timestamp time,
  ) {
    final index =
        data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final serialTransaction = data.serialTransactions[index];

    // if not month => seconds
    var newEndTime = Timestamp.fromDate(
      time.toDate().subtract(
            Duration(
              seconds: serialTransaction.repeatDuration,
            ),
          ),
    );

    if (serialTransaction.repeatDurationType.name.toUpperCase() == "MONTHS") {
      newEndTime = Timestamp.fromDate(
        DateTime(
          time.toDate().year,
          time.toDate().month - serialTransaction.repeatDuration,
          time.toDate().day,
        ),
      );
    }
    data.serialTransactions[index] =
        serialTransaction.copyWith(endTime: newEndTime);
    return true;
  }

  static bool removeOnlyThisOne(
    BalanceDocument data,
    String id,
    Timestamp time,
  ) {
    final index =
        data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final serialTransaction = data.serialTransactions[index];

    final changed = serialTransaction.changed ?? DateTimeMap();

    changed.addAll({
      time.millisecondsSinceEpoch.toString(): ChangedTransaction(deleted: true)
    });

    data.serialTransactions[index] =
        serialTransaction.copyWith(changed: changed);

    return true;
  }
}
