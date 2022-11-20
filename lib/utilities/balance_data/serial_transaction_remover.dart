//  Repeated Balance Data Remover - augments the StreamBuilder Manager with repeatable-specific Elements
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/changed_transaction.dart';
import 'package:linum/types/date_time_map.dart';

class SerialTransactionRemover {
  static bool removeAll(BalanceDocument data, String id) {
    final int length = data.serialTransactions.length;
    data.serialTransactions.removeWhere((element) {
      return element.id == id;
    });
    if (length == data.serialTransactions.length) {
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
    final index = data.serialTransactions.indexWhere((serial) => serial.id == id);
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
          time.toDate().month +
              serialTransaction.repeatDuration,
          time.toDate().day,
        ),
      );
    }

    data.serialTransactions[index] = serialTransaction.copyWith(initialTime: newInitialTime);

    return true;
  }

  static bool removeThisAndAllAfter(
    BalanceDocument data,
    String id,
    Timestamp time,
  ) {
    final index = data.serialTransactions.indexWhere((serial) => serial.id == id);
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
    print(newEndTime.toDate().toString());
    data.serialTransactions[index] = serialTransaction.copyWith(endTime: newEndTime);
    return true;
  }

  static bool removeOnlyThisOne(
    BalanceDocument data,
    String id,
    Timestamp time,
  ) {
    final index = data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final serialTransaction = data.serialTransactions[index];

    final changed = serialTransaction.changed ?? DateTimeMap();


    changed.addAll({
      time.millisecondsSinceEpoch.toString(): ChangedTransaction(deleted: true)
    });

    data.serialTransactions[index] = serialTransaction.copyWith(changed: changed);

    return true;
  }
}
