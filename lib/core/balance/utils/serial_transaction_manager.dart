//  Repeated Balance Data Manager - manages all possible interactions with repeated Balances
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/changed_transaction.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/utils/date_time_calculation_functions.dart';
import 'package:linum/core/balance/utils/serial_transaction_remover.dart';
import 'package:linum/core/balance/utils/serial_transaction_updater.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:linum/core/repeating/utils/repeated_balance_help_functions.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class SerialTransactionManager {
  static final Logger logger = Logger();

  /// add a repeated Balance and upload it (the stream will automatically show it in the app again)
  static bool addSerialTransactionToData(
    SerialTransaction serialTransaction,
    BalanceDocument data,
  ) {
    // conditions
    if (serialTransaction.category == "") {
      logger.e("repeatBalanceData.category must be != '' ");
      return false;
    }
    if (serialTransaction.currency == "") {
      logger.e("repeatBalanceData.currency must be != '' ");
      return false;
    }

    data.serialTransactions.add(serialTransaction);
    return true;
  }

  static bool updateSerialTransactionInData({
    required SerialTransactionChangeMode changeType,
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
      logger.e("no id provided");
      return false;
    }
    if (changeType == SerialTransactionChangeMode.thisAndAllBefore) {
      if (time == null) {
        logger.e("RepeatableChangeType.thisAndAllBefore => time != null");
        return false;
      }
      if (resetEndTime) {
        logger.e(
          "resetEndTime, endTime are no available for RepeatableChangeType.thisAndAllBefore",
        );
        return false;
      }
    }
    if (changeType == SerialTransactionChangeMode.thisAndAllAfter) {
      if (time == null) {
        logger.e("RepeatableChangeType.thisAndAllAfter => time != null");
        return false;
      }
      if (initialTime != null) {
        logger.e(
          "initialTime is no available for RepeatableChangeType.thisAndAllAfter",
        );
        return false;
      }
    }
    if (changeType == SerialTransactionChangeMode.onlyThisOne) {
      if (time == null) {
        logger.e("RepeatableChangeType.onlyThisOne => time != null");
        return false;
      }
    }
    if (category == "") {
      logger.e("category must be != '' ");
      return false;
    }
    if (currency == "") {
      logger.e("currency must be != '' ");
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

    for (final serialTransaction in data.serialTransactions) {
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
      case SerialTransactionChangeMode.all:
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
      case SerialTransactionChangeMode.thisAndAllBefore:
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
      case SerialTransactionChangeMode.thisAndAllAfter:
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

      case SerialTransactionChangeMode.onlyThisOne:
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
    required SerialTransactionChangeMode removeType,
    firestore.Timestamp? time,
  }) {
    // conditions
    if (removeType == SerialTransactionChangeMode.thisAndAllBefore &&
        time == null) {
      logger.e(
        "removeType == RepeatableChangeType.thisAndAllBefore => time != null",
      );
      return false;
    }
    if (removeType == SerialTransactionChangeMode.thisAndAllAfter &&
        time == null) {
      logger.e(
        "removeType == RepeatableChangeType.thisAndAllAfter => time != null",
      );
      return false;
    }
    if (removeType == SerialTransactionChangeMode.onlyThisOne && time == null) {
      logger
          .e("removeType == RepeatableChangeType.onlyThisOne => time != null");
      return false;
    }

    switch (removeType) {
      case SerialTransactionChangeMode.all:
        return SerialTransactionRemover.removeAll(data, id);
      case SerialTransactionChangeMode.thisAndAllBefore:
        return SerialTransactionRemover.removeThisAndAllBefore(
          data,
          id,
          time!,
        );
      case SerialTransactionChangeMode.thisAndAllAfter:
        final value = SerialTransactionRemover.removeThisAndAllAfter(
          data,
          id,
          time!,
        );
        return value;
      case SerialTransactionChangeMode.onlyThisOne:
        return SerialTransactionRemover.removeOnlyThisOne(data, id, time!);
    }
  }

  // Local Data generation

  /// goes trough the repeatable list and uses addSingleRepeatableToBalanceDataLocally
  /// TODO: DOC: WHY DOES IT DO THAT?
  static void addAllSerialTransactionsToTransactionsLocally(
    List<SerialTransaction> serialTransactions,
    List<Transaction> transactions,
    DateTime tillDate,
  ) {
    for (final serialTransaction in serialTransactions) {
      addSerialTransactionsToTransactionsLocally(
        serialTransaction,
        transactions,
        tillDate,
      );
    }
  }

  /// adds a repeatable for the whole needed duration up to one year with all needed "changes" into the balancedata
  static void addSerialTransactionsToTransactionsLocally(
    SerialTransaction serialTransaction,
    List<Transaction> transaction,
    DateTime tillDate,
  ) {
    DateTime currentTime = serialTransaction.initialTime.toDate();

    // while we are before 1 years after today / before endTime
    while ((serialTransaction.endTime == null ||
            !serialTransaction.endTime!.toDate().isBefore(currentTime)) &&
        !tillDate.isBefore(currentTime)) {
      // if "changed" -> "this firestore.Timestamp" -> deleted exist AND it is true, dont add this balance
      if (serialTransaction.changed == null ||
          serialTransaction.changed![currentTime] == null ||
          serialTransaction.changed![currentTime]!.deleted == null ||
          !serialTransaction.changed![currentTime]!.deleted!) {
        transaction.add(
          Transaction(
            amount: serialTransaction.changed?[currentTime]?.amount ??
                serialTransaction.amount,
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
                ? firestore.Timestamp.fromDate(currentTime)
                : null,
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
