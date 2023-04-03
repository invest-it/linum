//  Repeated Balance Data Updater - augments the StreamBuilder Manager with repeatable-specific Elements
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)
//
//  300 ZEILEN PURER HASS

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:linum/common/utils/date_time_map.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/changed_transaction.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/utils/date_time_calculation_functions.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:linum/core/repeating/utils/repeated_balance_help_functions.dart';
import 'package:uuid/uuid.dart';

class SerialTransactionUpdater {
  static bool updateAll({
    required BalanceDocument data,
    required String id,
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
     Timestamp? endDate,
     Timestamp? startDate,
    String? name,
    String? note,
     Timestamp? newDate,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool resetEndDate = false,
     Timestamp? oldDate,
  }) {
    bool isEdited = false;

    final index =
        data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final serialTransaction = data.serialTransactions[index];

    num? updatedAmount;
    String? updatedCategory;
    String? updatedCurrency;
    String? updatedName;
    String? updatedNote;
    DateTimeMap<String, ChangedTransaction>? updatedChanged =
        serialTransaction.changed;
     Timestamp? updatedInitialTime;
     Timestamp? updatedEndTime;
    int? updatedRepeatDuration;
    RepeatDurationType? updatedRepeatDurationType;

    if (amount != null && amount != serialTransaction.amount) {
      updatedAmount = amount;
      isEdited = true;
    }
    if (category != null && category != serialTransaction.category) {
      updatedCategory = category;
      isEdited = true;
    }
    if (currency != null && currency != serialTransaction.currency) {
      updatedCurrency = currency;
      isEdited = true;
    }
    if (name != null && name != serialTransaction.name) {
      updatedName = name;
      isEdited = true;
    }
    if ((note != null && note != serialTransaction.note) ||
        (deleteNote != null && deleteNote)) {
      updatedNote = note;
      isEdited = true;
    }
    if (startDate != null && startDate != serialTransaction.startDate) {
      updatedInitialTime = startDate;
      isEdited = true;
    } else if (newDate != null && oldDate != null) {
      updatedInitialTime =  Timestamp.fromDate(
        (serialTransaction.startDate).toDate().subtract(
              oldDate.toDate().difference(newDate.toDate()),
            ),
      );
      if (serialTransaction.endDate != null) {
        updatedEndTime =  Timestamp.fromDate(
          serialTransaction.endDate!.toDate().subtract(
                oldDate.toDate().difference(newDate.toDate()),
              ),
        );
      }
      isEdited = true;
    }
    if (repeatDuration != null &&
        repeatDuration != serialTransaction.repeatDuration) {
      updatedRepeatDuration = repeatDuration;
      isEdited = true;
    }
    if (repeatDurationType != null &&
        repeatDurationType != serialTransaction.repeatDurationType) {
      updatedRepeatDurationType = repeatDurationType;
      isEdited = true;
    }
    if (endDate != null && endDate != serialTransaction.endDate) {
      updatedEndTime = endDate;
      isEdited = true;
    }
    if (resetEndDate) {
      updatedEndTime = null;
      isEdited = true;
    }
    if (startDate != null ||
        repeatDuration != null ||
        repeatDurationType != null ||
        (newDate != null && oldDate != null)) {
      // FUTURE lazy approach. might think of something clever in the future
      // (what if repeat duration changes. single repeatable changes change time or not? use the nth? complicated...)
      updatedChanged = null;
    }

    if (isEdited && serialTransaction.changed != null) {
      serialTransaction.changed?.forEach((key, value) {
        if (amount != null) {
          value.amount = null;
        }
        if (category != null) {
          value.category = null;
        }
        if (currency != null) {
          value.currency = null;
        }
        if (name != null) {
          value.name = null;
        }
        if (note != null || (deleteNote != null && deleteNote)) {
          value.note = null;
        }
        if (newDate != null) {
          value.date = null;
        }
        // TODO: Ganz großes Fragezeichen
        // dont need startDate
        // dont need repeatDuration
        // dont need repeatDurationType
        // dont need endDate
        // dont need resetEndTime,
      });
    }

    final updatedSerialTransaction = SerialTransaction(
      id: serialTransaction.id,
      amount: updatedAmount ?? serialTransaction.amount,
      category: updatedCategory ?? serialTransaction.category,
      currency: updatedCurrency ?? serialTransaction.currency,
      startDate: updatedInitialTime ?? serialTransaction.startDate,
      endDate:
          resetEndDate ? null : (updatedEndTime ?? serialTransaction.endDate),
      name: updatedName ?? serialTransaction.name,
      note: updatedNote ?? serialTransaction.note,
      changed: updatedChanged,
      repeatDuration: updatedRepeatDuration ?? serialTransaction.repeatDuration,
      repeatDurationType:
          updatedRepeatDurationType ?? serialTransaction.repeatDurationType,
    );

    data.serialTransactions[index] = updatedSerialTransaction;

    return isEdited;
  }

  static bool updateThisAndAllBefore({
    required BalanceDocument data,
    required String id,
    required  Timestamp oldDate,
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
     Timestamp? endDate,
     Timestamp? startDate,
    String? name,
    String? note,
     Timestamp? newDate,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndDate,
  }) {
    bool isEdited = false;

    final index =
        data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final oldSerialTransaction = data.serialTransactions[index];

     Timestamp? updatedInitialTime;

    if (oldSerialTransaction.repeatDurationType.name.toUpperCase() ==
        "MONTHS") {
      updatedInitialTime =  Timestamp.fromDate(
        calculateOneTimeStep(
          oldSerialTransaction.repeatDuration,
          oldDate.toDate(),
          monthly: true,
          dayOfTheMonth: oldDate.toDate().day,
        ),
      );
    } else {
      updatedInitialTime =  Timestamp.fromDate(
        calculateOneTimeStep(
          oldSerialTransaction.repeatDuration,
          oldDate.toDate(),
          monthly: false,
        ),
      );
    }
    final Duration timeDifference =
        oldDate.toDate().difference(newDate?.toDate() ?? oldDate.toDate());

    final newSerialTransaction = oldSerialTransaction.copyWith(
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      startDate: startDate ??
           Timestamp.fromDate(
            oldSerialTransaction.startDate.toDate().subtract(timeDifference),
          ),
      id: const Uuid().v4(),
      repeatDuration: repeatDuration,
      repeatDurationType: repeatDurationType,
      endDate:
           Timestamp.fromDate(oldDate.toDate().subtract(timeDifference)),
      note: (deleteNote ?? false) ? null : note,
    );

    removeUnusedChangedAttributes(newSerialTransaction);
    removeUnusedChangedAttributes(oldSerialTransaction);

    isEdited = true;

    data.serialTransactions[index] = oldSerialTransaction.copyWith(
      startDate: updatedInitialTime,
    );

    data.serialTransactions.add(newSerialTransaction);

    return isEdited;
  }

  static bool updateThisAndAllAfter({
    required BalanceDocument data,
    required String id,
    required  Timestamp oldDate,
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
     Timestamp? endDate,
     Timestamp? startDate,
    String? name,
     Timestamp? newDate,
    String? note,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndDate,
  }) {
    bool isEdited = false;

    final index = data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final oldSerialTransaction = data.serialTransactions[index];

     Timestamp? updatedEndTime;

    if (oldSerialTransaction.repeatDurationType.name.toUpperCase() == "MONTHS") {
      updatedEndTime =  Timestamp.fromDate(
        calculateOneTimeStepBackwards(
          oldSerialTransaction.repeatDuration,
          oldDate.toDate(),
          monthly: true,
          dayOfTheMonth: oldDate.toDate().day,
        ),
      );
    } else {
      updatedEndTime =  Timestamp.fromDate(
        calculateOneTimeStepBackwards(
          oldSerialTransaction.repeatDuration,
          oldDate.toDate(),
          monthly: false,
          dayOfTheMonth: oldDate.toDate().day,
        ),
      );
    }
    final Duration timeDifference =
        oldDate.toDate().difference(newDate?.toDate() ?? oldDate.toDate());

    final newSerialTransaction = oldSerialTransaction.copyWith(
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      startDate:
           Timestamp.fromDate(oldDate.toDate().subtract(timeDifference)),
      id: const Uuid().v4(),
      repeatDuration: repeatDuration,
      repeatDurationType: repeatDurationType,
      endDate: changeThisAndAllAfterEndTimeHelpFunction(
        endDate,
        oldSerialTransaction,
        timeDifference,
      ),
    );

    removeUnusedChangedAttributes(newSerialTransaction);
    removeUnusedChangedAttributes(oldSerialTransaction);

    isEdited = true;

    data.serialTransactions[index] =
        oldSerialTransaction.copyWith(endDate: updatedEndTime);

    data.serialTransactions.add(newSerialTransaction);

    return isEdited;
  }

  // TODO: Delete note
  static bool updateOnlyThisOne({
    required BalanceDocument data,
    required String id,
    required  Timestamp date,
    required ChangedTransaction changed,
  }) {
    final index =
        data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final serialTransaction = data.serialTransactions[index];
    final changedMap = serialTransaction.changed ?? DateTimeMap();

    changedMap.addAll({date.millisecondsSinceEpoch.toString(): changed});

    data.serialTransactions[index] =
        serialTransaction.copyWith(changed: changedMap);

    return true;
  }
}
