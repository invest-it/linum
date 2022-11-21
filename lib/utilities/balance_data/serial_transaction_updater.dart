//  Repeated Balance Data Updater - augments the StreamBuilder Manager with repeatable-specific Elements
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)
//
//  300 ZEILEN PURER HASS

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/changed_transaction.dart';
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/types/date_time_map.dart';
import 'package:linum/utilities/backend/date_time_calculation_functions.dart';
import 'package:linum/utilities/backend/repeated_balance_help_functions.dart';

import 'package:uuid/uuid.dart';

class SerialTransactionUpdater {
  static bool updateAll({
    required BalanceDocument data,
    required String id,
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
    firestore.Timestamp? endTime,
    firestore.Timestamp? initialTime,
    String? name,
    String? note,
    firestore.Timestamp? newTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool resetEndTime = false,
    firestore.Timestamp? time,
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
    firestore.Timestamp? updatedInitialTime;
    firestore.Timestamp? updatedEndTime;
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
    if (initialTime != null && initialTime != serialTransaction.initialTime) {
      updatedInitialTime = initialTime;
      isEdited = true;
    } else if (newTime != null && time != null) {
      updatedInitialTime = firestore.Timestamp.fromDate(
        (serialTransaction.initialTime).toDate().subtract(
              time.toDate().difference(newTime.toDate()),
            ),
      );
      if (serialTransaction.endTime != null) {
        updatedEndTime = firestore.Timestamp.fromDate(
          serialTransaction.endTime!.toDate().subtract(
                time.toDate().difference(newTime.toDate()),
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
    if (endTime != null && endTime != serialTransaction.endTime) {
      updatedEndTime = endTime;
      isEdited = true;
    }
    if (resetEndTime) {
      updatedEndTime = null;
      isEdited = true;
    }
    if (initialTime != null ||
        repeatDuration != null ||
        repeatDurationType != null ||
        (newTime != null && time != null)) {
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
        if (newTime != null) {
          value.time = null;
        }
        // TODO: Ganz großes Fragezeichen
        // dont need initialTime
        // dont need repeatDuration
        // dont need repeatDurationType
        // dont need endTime
        // dont need resetEndTime,
      });
    }

    final updatedSerialTransaction = SerialTransaction(
      id: serialTransaction.id,
      amount: updatedAmount ?? serialTransaction.amount,
      category: updatedCategory ?? serialTransaction.category,
      currency: updatedCurrency ?? serialTransaction.currency,
      initialTime: updatedInitialTime ?? serialTransaction.initialTime,
      endTime:
          resetEndTime ? null : (updatedEndTime ?? serialTransaction.endTime),
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
    required firestore.Timestamp time,
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
    firestore.Timestamp? endTime,
    firestore.Timestamp? initialTime,
    String? name,
    String? note,
    firestore.Timestamp? newTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndTime,
  }) {
    bool isEdited = false;

    final index =
        data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final oldSerialTransaction = data.serialTransactions[index];

    firestore.Timestamp? updatedInitialTime;

    if (oldSerialTransaction.repeatDurationType.name.toUpperCase() ==
        "MONTHS") {
      updatedInitialTime = firestore.Timestamp.fromDate(
        calculateOneTimeStep(
          oldSerialTransaction.repeatDuration,
          time.toDate(),
          monthly: true,
          dayOfTheMonth: time.toDate().day,
        ),
      );
    } else {
      updatedInitialTime = firestore.Timestamp.fromDate(
        calculateOneTimeStep(
          oldSerialTransaction.repeatDuration,
          time.toDate(),
          monthly: false,
        ),
      );
    }
    final Duration timeDifference =
        time.toDate().difference(newTime?.toDate() ?? time.toDate());

    final newSerialTransaction = oldSerialTransaction.copyWith(
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      initialTime: initialTime ??
          firestore.Timestamp.fromDate(
            oldSerialTransaction.initialTime.toDate().subtract(timeDifference),
          ),
      id: const Uuid().v4(),
      repeatDuration: repeatDuration,
      repeatDurationType: repeatDurationType,
      endTime:
          firestore.Timestamp.fromDate(time.toDate().subtract(timeDifference)),
      note: (deleteNote ?? false) ? null : note,
    );

    removeUnusedChangedAttributes(newSerialTransaction);
    removeUnusedChangedAttributes(oldSerialTransaction);

    isEdited = true;

    data.serialTransactions[index] = oldSerialTransaction.copyWith(
      initialTime: updatedInitialTime,
    );

    data.serialTransactions.add(newSerialTransaction);

    return isEdited;
  }

  static bool updateThisAndAllAfter({
    required BalanceDocument data,
    required String id,
    required firestore.Timestamp time,
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
    firestore.Timestamp? endTime,
    firestore.Timestamp? initialTime,
    String? name,
    firestore.Timestamp? newTime,
    String? note,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndTime,
  }) {
    bool isEdited = false;

    final index = data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final oldSerialTransaction = data.serialTransactions[index];

    firestore.Timestamp? updatedEndTime;

    if (oldSerialTransaction.repeatDurationType.name.toUpperCase() == "MONTHS") {
      updatedEndTime = firestore.Timestamp.fromDate(
        calculateOneTimeStepBackwards(
          oldSerialTransaction.repeatDuration,
          time.toDate(),
          monthly: true,
          dayOfTheMonth: time.toDate().day,
        ),
      );
    } else {
      updatedEndTime = firestore.Timestamp.fromDate(
        calculateOneTimeStepBackwards(
          oldSerialTransaction.repeatDuration,
          time.toDate(),
          monthly: false,
          dayOfTheMonth: time.toDate().day,
        ),
      );
    }
    final Duration timeDifference =
        time.toDate().difference(newTime?.toDate() ?? time.toDate());

    final newSerialTransaction = oldSerialTransaction.copyWith(
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      initialTime:
          firestore.Timestamp.fromDate(time.toDate().subtract(timeDifference)),
      id: const Uuid().v4(),
      repeatDuration: repeatDuration,
      repeatDurationType: repeatDurationType,
      endTime: changeThisAndAllAfterEndTimeHelpFunction(
        endTime,
        oldSerialTransaction,
        timeDifference,
      ),
    );

    removeUnusedChangedAttributes(newSerialTransaction);
    removeUnusedChangedAttributes(oldSerialTransaction);

    isEdited = true;

    data.serialTransactions[index] =
        oldSerialTransaction.copyWith(endTime: updatedEndTime);

    data.serialTransactions.add(newSerialTransaction);

    return isEdited;
  }

  // TODO: Delete note
  static bool updateOnlyThisOne({
    required BalanceDocument data,
    required String id,
    required firestore.Timestamp time,
    required ChangedTransaction changed,
  }) {
    final index =
        data.serialTransactions.indexWhere((serial) => serial.id == id);
    if (index == -1) {
      return false;
    }
    final serialTransaction = data.serialTransactions[index];

    final changedMap = serialTransaction.changed ?? DateTimeMap();

    changedMap.addAll({time.millisecondsSinceEpoch.toString(): changed});

    data.serialTransactions[index] =
        serialTransaction.copyWith(changed: changedMap);

    return true;
  }
}
