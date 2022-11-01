//  Repeated Balance Data Manager - manages all possible interactions with repeated Balances
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/constants/serial_transaction_change_type_enum.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/changed_transaction.dart';
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/utilities/backend/date_time_calculation_functions.dart';
import 'package:linum/utilities/backend/repeated_balance_help_functions.dart';
import 'package:linum/utilities/balance_data/serial_transaction_remover.dart';
import 'package:linum/utilities/balance_data/serial_transaction_updater.dart';
import 'package:uuid/uuid.dart';

class SerialTransactionManager {
  /// add a repeated Balance and upload it (the stream will automatically show it in the app again)
  static bool addSerialTransactionToData(
    SerialTransaction serialTransaction,
    BalanceDocument data,
  ) {
    // conditions
    if (serialTransaction.category == "") {
      dev.log("repeatBalanceData.category must be != '' ");
      return false;
    }
    if (serialTransaction.currency == "") {
      dev.log("repeatBalanceData.currency must be != '' ");
      return false;
    }

    data.serialTransactions.add(serialTransaction);
    return true;
  }

  static bool updateSerialTransactionInData({
    required SerialTransactionChangeType changeType,
    required String id,
    required BalanceDocument data,
    num? amount,
    String? category,
    String? currency,
    String? name,
    String? note,
    bool? deleteNote,
    firestore.Timestamp? initialTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    firestore.Timestamp? endTime,
    bool resetEndTime = false,
    firestore.Timestamp? time,
    firestore.Timestamp? newTime,
  }) {
    // conditions
    if (id == "") {
      dev.log("no id provided");
      return false;
    }
    if (changeType == SerialTransactionChangeType.thisAndAllBefore) {
      if (time == null) {
        dev.log("RepeatableChangeType.thisAndAllBefore => time != null");
        return false;
      }
      if (resetEndTime) {
        dev.log(
          "resetEndTime, endTime are no available for RepeatableChangeType.thisAndAllBefore",
        );
        return false;
      }
    }
    if (changeType == SerialTransactionChangeType.thisAndAllAfter) {
      if (time == null) {
        dev.log("RepeatableChangeType.thisAndAllAfter => time != null");
        return false;
      }
      if (initialTime != null) {
        dev.log(
          "initialTime is no available for RepeatableChangeType.thisAndAllAfter",
        );
        return false;
      }
    }
    if (changeType == SerialTransactionChangeType.onlyThisOne) {
      if (time == null) {
        dev.log("RepeatableChangeType.onlyThisOne => time != null");
        return false;
      }
    }
    if (category == "") {
      dev.log("category must be != '' ");
      return false;
    }
    if (currency == "") {
      dev.log("currency must be != '' ");
      return false;
    }

    // check if changes happen

    num? checkedAmount;
    String? checkedCategory;
    String? checkedCurrency;
    String? checkedName;
    String? checkedNote;
    firestore.Timestamp? checkedInitialTime;
    int? checkedRepeatDuration;
    RepeatDurationType? checkedRepeatDurationType;
    firestore.Timestamp? checkedEndTime;
    firestore.Timestamp? checkedNewTime;

    for (final serialTransaction
        in data.serialTransactions) {
      if (serialTransaction.id == id) {
        if (amount != serialTransaction.amount) {
          checkedAmount = amount;
        }
        if (category != serialTransaction.category) {
          checkedCategory = category;
        }
        if (currency != serialTransaction.currency) {
          checkedCurrency = currency;
        }
        if (name != serialTransaction.name) {
          checkedName = name;
        }
        if (note != serialTransaction.note) {
          checkedNote = note;
        }
        if (initialTime != serialTransaction.initialTime) {
          checkedInitialTime = initialTime;
        }
        if (repeatDuration != serialTransaction.repeatDuration) {
          checkedRepeatDuration = repeatDuration;
        }
        if (repeatDurationType != serialTransaction.repeatDurationType) {
          checkedRepeatDurationType = repeatDurationType;
        }
        if (endTime != serialTransaction.endTime) {
          checkedEndTime = endTime;
        }
        if (newTime != time) {
          checkedNewTime = newTime;
        }

        break;
      }
    }

    switch (changeType) {
      case SerialTransactionChangeType.all:
        return SerialTransactionUpdater.updateAll(
          amount: checkedAmount,
          category: checkedCategory,
          currency: checkedCurrency,
          data: data,
          deleteNote: deleteNote,
          endTime: checkedEndTime,
          id: id,
          initialTime: checkedInitialTime,
          name: checkedName,
          note: checkedNote,
          newTime: checkedNewTime,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndTime: resetEndTime,
          time: time,
        );
      case SerialTransactionChangeType.thisAndAllBefore:
        return SerialTransactionUpdater.updateThisAndAllBefore(
          amount: checkedAmount,
          category: checkedCategory,
          currency: checkedCurrency,
          data: data,
          deleteNote: deleteNote,
          endTime: checkedEndTime,
          id: id,
          initialTime: checkedInitialTime,
          name: checkedName,
          note: checkedNote,
          newTime: checkedNewTime,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndTime: resetEndTime,
          time: time!,
        );
      case SerialTransactionChangeType.thisAndAllAfter:
        return SerialTransactionUpdater.updateThisAndAllAfter(
          amount: checkedAmount,
          category: checkedCategory,
          currency: checkedCurrency,
          data: data,
          deleteNote: deleteNote,
          endTime: checkedEndTime,
          id: id,
          initialTime: checkedInitialTime,
          name: checkedName,
          newTime: checkedNewTime,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndTime: resetEndTime,
          time: time!,
        );

      case SerialTransactionChangeType.onlyThisOne:
        return SerialTransactionUpdater.updateOnlyThisOne(
          data: data,
          id: id,
          time: time!,
          changed: ChangedTransaction(
              amount: checkedAmount,
              category: checkedCategory,
              currency: checkedCurrency,
              name: checkedName,
              note: checkedNote,
              time: checkedNewTime,
          ),
        );
    }
  }

 static bool removeSerialTransactionFromData({
    required String id,
    required BalanceDocument data,
    required SerialTransactionChangeType removeType,
    firestore.Timestamp? time,
  }) {
    // conditions
    if (removeType == SerialTransactionChangeType.thisAndAllBefore && time == null) {
      dev.log(
        "removeType == RepeatableChangeType.thisAndAllBefore => time != null",
      );
      return false;
    }
    if (removeType == SerialTransactionChangeType.thisAndAllAfter && time == null) {
      dev.log(
        "removeType == RepeatableChangeType.thisAndAllAfter => time != null",
      );
      return false;
    }
    if (removeType == SerialTransactionChangeType.onlyThisOne && time == null) {
      dev.log("removeType == RepeatableChangeType.onlyThisOne => time != null");
      return false;
    }

    switch (removeType) {
      case SerialTransactionChangeType.all:
        return SerialTransactionRemover.removeAll(data, id);
      case SerialTransactionChangeType.thisAndAllBefore:
        return SerialTransactionRemover.removeThisAndAllBefore(
          data,
          id,
          time!,
        );
      case SerialTransactionChangeType.thisAndAllAfter:
        return SerialTransactionRemover.removeThisAndAllAfter(
          data,
          id,
          time!,
        );
      case SerialTransactionChangeType.onlyThisOne:
        return SerialTransactionRemover.removeOnlyThisOne(data, id, time!);
    }
  }

  // Local Data generation

  /// goes trough the repeatable list and uses addSingleRepeatableToBalanceDataLocally
  /// TODO: DOC: WHY DOES IT DO THAT?
  static void addAllSerialTransactionsToTransactionsLocally(
    List<SerialTransaction> serialTransactions,
    List<Transaction> transactions,
  ) {
    for (final serialTransaction in serialTransactions) {
      addSerialTransactionsToTransactionsLocally(
        serialTransaction,
        transactions,
      );
    }
  }

  /// adds a repeatable for the whole needed duration up to one year with all needed "changes" into the balancedata
  static void addSerialTransactionsToTransactionsLocally(
    SerialTransaction serialTransaction,
    List<Transaction> transaction,
  ) {
    DateTime currentTime =
        serialTransaction.initialTime.toDate();

    const Duration futureDuration = Duration(days: 365);

    // while we are before 1 years after today / before endTime
    while ((serialTransaction.endTime != null)
        // !isbefore => currentime = endtime = true
        ? !serialTransaction.endTime!.toDate().isBefore(currentTime)
        : DateTime.now().add(futureDuration).isAfter(currentTime)) {
      // if "changed" -> "this firestore.Timestamp" -> deleted exist AND it is true, dont add this balance
      if (serialTransaction.changed == null
          || serialTransaction.changed![currentTime] == null
          || serialTransaction.changed![currentTime]!.deleted == null
          || !serialTransaction.changed![currentTime]!.deleted!) {
        transaction.add(
            Transaction(
              amount: serialTransaction.changed?[currentTime]?.amount
                  ?? serialTransaction.amount,
              category: serialTransaction.changed?[currentTime]?.category ??
                  serialTransaction.category,
              currency: serialTransaction.changed?[currentTime]?.currency ??
                  serialTransaction.currency,
              name: serialTransaction.changed?[currentTime]?.name ??
                  serialTransaction.name,
              time: serialTransaction.changed?[currentTime]?.time ??
                  firestore.Timestamp.fromDate(currentTime),
              repeatId: serialTransaction.id,
              id: const Uuid().v4(),
              formerTime: (serialTransaction.changed?[currentTime]?.time != null)
                  ? firestore.Timestamp.fromDate(currentTime) : null,
            ),
        );
      }
      currentTime = calculateOneTimeStep(
        serialTransaction.repeatDuration,
        currentTime,
        // is it a month or second duration type
        monthly: isMonthly(serialTransaction),
        dayOfTheMonth: serialTransaction.initialTime.toDate().day,
      );
    }
  }
}
