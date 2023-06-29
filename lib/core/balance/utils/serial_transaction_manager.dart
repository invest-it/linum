//  Repeated Balance Data Manager - manages all possible interactions with repeated Balances
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:collection/collection.dart';
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
     Timestamp? startDate,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
     Timestamp? endDate,
    bool resetEndDate = false,
     Timestamp? oldDate,
     Timestamp? newDate,
  }) {
    // conditions
    if (id == "") {
      logger.e("no id provided");
      return false;
    }
    if (changeType == SerialTransactionChangeMode.thisAndAllBefore) {
      if (oldDate == null) {
        logger.e("RepeatableChangeType.thisAndAllBefore => date != null");
        return false;
      }
      if (resetEndDate) {
        logger.e(
          "resetEndTime, endDate are no available for RepeatableChangeType.thisAndAllBefore",
        );
        return false;
      }
    }
    if (changeType == SerialTransactionChangeMode.thisAndAllAfter) {
      if (oldDate == null) {
        logger.e("RepeatableChangeType.thisAndAllAfter => date != null");
        return false;
      }
      if (startDate != null) {
        logger.e(
          "startDate is no available for RepeatableChangeType.thisAndAllAfter",
        );
        return false;
      }
    }
    if (changeType == SerialTransactionChangeMode.onlyThisOne) {
      if (oldDate == null) {
        logger.e("RepeatableChangeType.onlyThisOne => date != null");
        return false;
      }
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
    Timestamp? checkedInitialTime;
    int? checkedRepeatDuration;
    RepeatDurationType? checkedRepeatDurationType;
    Timestamp? checkedEndTime;
    Timestamp? checkedNewDate;

    final serialTransaction = data.serialTransactions
        .firstWhereOrNull((st) => st.id == id);

    if (serialTransaction != null) {
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
      if (startDate != serialTransaction.startDate) {
        checkedInitialTime = startDate;
      }
      if (repeatDuration != serialTransaction.repeatDuration) {
        checkedRepeatDuration = repeatDuration;
      }
      if (repeatDurationType != serialTransaction.repeatDurationType) {
        checkedRepeatDurationType = repeatDurationType;
      }
      if (endDate != serialTransaction.endDate) {
        checkedEndTime = endDate;
      }
      if (newDate != oldDate) {
        checkedNewDate = newDate;
      }
    }


    switch (changeType) {
      case SerialTransactionChangeMode.all:
        return SerialTransactionUpdater.updateAll(
          amount: checkedAmount,
          category: checkedCategory, // TODO Null value might be a problem
          currency: checkedCurrency,
          data: data,
          deleteNote: deleteNote,
          endDate: checkedEndTime,
          id: id,
          startDate: checkedInitialTime,
          name: checkedName,
          note: checkedNote,
          newDate: checkedNewDate,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndDate: resetEndDate,
          oldDate: oldDate,
        );
      case SerialTransactionChangeMode.thisAndAllBefore:
        return SerialTransactionUpdater.updateThisAndAllBefore(
          amount: checkedAmount,
          category: checkedCategory, // TODO Null value might be a problem
          currency: checkedCurrency,
          data: data,
          deleteNote: deleteNote,
          endDate: checkedEndTime,
          id: id,
          startDate: checkedInitialTime,
          name: checkedName,
          note: checkedNote,
          newDate: checkedNewDate,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndDate: resetEndDate,
          oldDate: oldDate!,
        );
      case SerialTransactionChangeMode.thisAndAllAfter:
        return SerialTransactionUpdater.updateThisAndAllAfter(
          amount: checkedAmount,
          category: checkedCategory, // TODO Null value might be a problem
          currency: checkedCurrency,
          data: data,
          deleteNote: deleteNote,
          endDate: checkedEndTime,
          id: id,
          startDate: checkedInitialTime,
          name: checkedName,
          newDate: checkedNewDate,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndDate: resetEndDate,
          oldDate: oldDate!,
        );

      case SerialTransactionChangeMode.onlyThisOne:
        return SerialTransactionUpdater.updateOnlyThisOne(
          data: data,
          id: id,
          date: oldDate!,
          changed: ChangedTransaction(
            amount: checkedAmount,
            category: checkedCategory, // TODO Null value might be a problem
            currency: checkedCurrency,
            name: checkedName,
            note: checkedNote,
            date: checkedNewDate,
          ),
        );
    }
  }

  static bool removeSerialTransactionFromData({
    required String id,
    required BalanceDocument data,
    required SerialTransactionChangeMode removeType,
     Timestamp? date,
  }) {
    // conditions
    if (removeType == SerialTransactionChangeMode.thisAndAllBefore &&
        date == null) {
      logger.e(
        "removeType == RepeatableChangeType.thisAndAllBefore => date != null",
      );
      return false;
    }
    if (removeType == SerialTransactionChangeMode.thisAndAllAfter &&
        date == null) {
      logger.e(
        "removeType == RepeatableChangeType.thisAndAllAfter => date != null",
      );
      return false;
    }
    if (removeType == SerialTransactionChangeMode.onlyThisOne && date == null) {
      logger
          .e("removeType == RepeatableChangeType.onlyThisOne => date != null");
      return false;
    }

    switch (removeType) {
      case SerialTransactionChangeMode.all:
        return SerialTransactionRemover.removeAll(data, id);
      case SerialTransactionChangeMode.thisAndAllBefore:
        return SerialTransactionRemover.removeThisAndAllBefore(
          data,
          id,
          date!,
        );
      case SerialTransactionChangeMode.thisAndAllAfter:
        final value = SerialTransactionRemover.removeThisAndAllAfter(
          data,
          id,
          date!,
        );
        return value;
      case SerialTransactionChangeMode.onlyThisOne:
        return SerialTransactionRemover.removeOnlyThisOne(data, id, date!);
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
    DateTime currentTime = serialTransaction.startDate.toDate();

    // while we are before 1 years after today / before endDate
    while ((serialTransaction.endDate == null ||
            !serialTransaction.endDate!.toDate().isBefore(currentTime)) &&
        !tillDate.isBefore(currentTime)) {
      // if "changed" -> "this  Timestamp" -> deleted exist AND it is true, dont add this balance
      if (serialTransaction.changed == null ||
          serialTransaction.changed!.get(currentTime) == null ||
          serialTransaction.changed!.get(currentTime)!.deleted == null ||
          !serialTransaction.changed!.get(currentTime)!.deleted!) {
        transaction.add(
          Transaction(
            amount: serialTransaction.changed?.get(currentTime)?.amount ??
                serialTransaction.amount,
            category: serialTransaction.changed?.get(currentTime)?.category ??
                serialTransaction.category,
            currency: serialTransaction.changed?.get(currentTime)?.currency ??
                serialTransaction.currency,
            name: serialTransaction.changed?.get(currentTime)?.name ??
                serialTransaction.name,
            date: serialTransaction.changed?.get(currentTime)?.date ??
                 Timestamp.fromDate(currentTime),
            repeatId: serialTransaction.id,
            id: const Uuid().v4(),
            formerDate: (serialTransaction.changed?.get(currentTime)?.date != null)
                ?  Timestamp.fromDate(currentTime)
                : null,
          ),
        );
      }
      currentTime = calculateOneTimeStep(
        serialTransaction.repeatDuration,
        currentTime,
        // is it a month or second duration type
        monthly: isMonthly(serialTransaction),
        dayOfTheMonth: serialTransaction.startDate.toDate().day,
      );
    }
  }
}
