//  Repeated Balance Data Updater - augments the StreamBuilder Manager with repeatable-specific Elements
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/changed_repeated_balance.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/types/date_time_map.dart';
import 'package:linum/utilities/backend/date_time_calculation_functions.dart';
import 'package:linum/utilities/backend/repeated_balance_help_functions.dart';
import 'package:uuid/uuid.dart';

class RepeatedBalanceDataUpdater {
  static bool updateAll({
    required BalanceDocument data,
    required String id,
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
    Timestamp? endTime,
    Timestamp? initialTime,
    String? name,
    String? note,
    Timestamp? newTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndTime,
    Timestamp? time,
  }) {
    bool isEdited = false;

    final singleRepeatedBalance = data.repeatedBalance.firstWhereOrNull((element) => element.id == id);
    if (singleRepeatedBalance == null) {
      return false;
    }


    if (amount != null) {
      singleRepeatedBalance.amount = amount;
      isEdited = true;
    }
    if (category != null && category != singleRepeatedBalance.category) {
      singleRepeatedBalance.category = category;
      isEdited = true;
    }
    if (currency != null && currency != singleRepeatedBalance.currency) {
      singleRepeatedBalance.currency = currency;
      isEdited = true;
    }
    if (name != null && name != singleRepeatedBalance.name) {
      singleRepeatedBalance.name = name;
      isEdited = true;
    }
    if ((note != null && note != singleRepeatedBalance.note) ||
        (deleteNote != null && deleteNote)) {
      singleRepeatedBalance.note = note;
      isEdited = true;
    }
    if (initialTime != null &&
        initialTime != singleRepeatedBalance.initialTime) {
      singleRepeatedBalance.initialTime = initialTime;
      isEdited = true;
    } else if (newTime != null && time != null) {
      singleRepeatedBalance.initialTime = Timestamp.fromDate(
        (singleRepeatedBalance.initialTime)
            .toDate()
            .subtract(
          time.toDate().difference(newTime.toDate()),
        ),
      );
      if (singleRepeatedBalance.endTime != null) {
        singleRepeatedBalance.endTime = Timestamp.fromDate(
          singleRepeatedBalance.endTime!.toDate().subtract(
            time.toDate().difference(newTime.toDate()),
          ),
        );
      }
      isEdited = true;
    }
    if (repeatDuration != null && repeatDuration != singleRepeatedBalance.repeatDuration) {
      singleRepeatedBalance.repeatDuration = repeatDuration;
      isEdited = true;
    }
    if (repeatDurationType != null &&
        repeatDurationType != singleRepeatedBalance.repeatDurationType) {
      singleRepeatedBalance.repeatDurationType = repeatDurationType;
      isEdited = true;
    }
    if (endTime != null && endTime != singleRepeatedBalance.endTime) {
      singleRepeatedBalance.endTime = endTime;
      isEdited = true;
    }
    if (resetEndTime != null && resetEndTime) {
      singleRepeatedBalance.endTime = null;
      isEdited = true;
    }
    if (initialTime != null ||
        repeatDuration != null ||
        repeatDurationType != null ||
        (newTime != null && time != null)) {
      // FUTURE lazy approach. might think of something clever in the future
      // (what if repeat duration changes. single repeatable changes change time or not? use the nth? complicated...)
      singleRepeatedBalance.changed = null;
    }

    if (isEdited && singleRepeatedBalance.changed != null) {
      singleRepeatedBalance.changed?.forEach((key, value) {
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
    return isEdited;
  }

  static bool updateThisAndAllBefore({
    required BalanceDocument data,
    required String id,
    required Timestamp time,
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
    Timestamp? endTime,
    Timestamp? initialTime,
    String? name,
    String? note,
    Timestamp? newTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndTime,
  }) {
    bool isEdited = false;
    RepeatedBalanceData? newRepeatedBalance;

    final oldRepeatedBalance = data.repeatedBalance.firstWhereOrNull((element) => element.id == id);
    if (oldRepeatedBalance == null) {
      return false;
    }

    newRepeatedBalance = oldRepeatedBalance.copyWith();
    newRepeatedBalance.id = const Uuid().v4();
    if (oldRepeatedBalance.repeatDurationType.toString().toUpperCase() == "MONTHS") {
      oldRepeatedBalance.initialTime = Timestamp.fromDate(
        calculateOneTimeStep(
          oldRepeatedBalance.repeatDuration,
          time.toDate(),
          monthly: true,
          dayOfTheMonth: time.toDate().day,
        ),
      );
    } else {
      oldRepeatedBalance.initialTime = Timestamp.fromDate(
        time.toDate()
            .add(Duration(seconds: oldRepeatedBalance.repeatDuration)),
      );
    }
    final Duration timeDifference =
    time.toDate().difference(newTime?.toDate() ?? time.toDate());

    newRepeatedBalance = newRepeatedBalance.copyWith(
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      initialTime: initialTime ??
          Timestamp.fromDate(newRepeatedBalance.initialTime.toDate().subtract(timeDifference)),
      repeatDuration: repeatDuration,
      repeatDurationType: repeatDurationType,
      endTime: Timestamp.fromDate(time.toDate().subtract(timeDifference)),
    );
    newRepeatedBalance.note = (deleteNote ?? false) ? null : note;

    removeUnusedChangedAttributes(newRepeatedBalance);
    removeUnusedChangedAttributes(oldRepeatedBalance);

    isEdited = true;

    data.repeatedBalance.add(newRepeatedBalance);

    return isEdited;
  }

  static bool updateThisAndAllAfter({
    required BalanceDocument data,
    required String id,
    required Timestamp time,
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
    Timestamp? endTime,
    Timestamp? initialTime,
    String? name,
    Timestamp? newTime,
    String? note,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndTime,
  }) {
    bool isEdited = false;
    RepeatedBalanceData? newRepeatedBalance;

    final oldRepeatedBalance = data.repeatedBalance.firstWhereOrNull((element) => element.id == id);
    if (oldRepeatedBalance == null) {
      return false;
    }

    newRepeatedBalance = oldRepeatedBalance.copyWith();
    newRepeatedBalance.id = const Uuid().v4();
    if (oldRepeatedBalance.repeatDurationType.toString().toUpperCase() == "MONTHS") {
      oldRepeatedBalance.endTime = Timestamp.fromDate(
        calculateOneTimeStepBackwards(
          oldRepeatedBalance.repeatDuration,
          time.toDate(),
          monthly: true,
          dayOfTheMonth: time.toDate().day,
        ),
      );
    } else {
      oldRepeatedBalance.endTime = Timestamp.fromDate(
        time.toDate().subtract(
          Duration(
            seconds: oldRepeatedBalance.repeatDuration,
          ),
        ),
      );
    }
    final Duration timeDifference =
    time.toDate().difference(newTime?.toDate() ?? time.toDate());


    newRepeatedBalance = newRepeatedBalance.copyWith(
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      initialTime: Timestamp.fromDate(time.toDate().subtract(timeDifference)),
      repeatDuration: repeatDuration,
      repeatDurationType: repeatDurationType,
      endTime: changeThisAndAllAfterEndTimeHelpFunction(
        endTime,
        newRepeatedBalance,
        timeDifference,
      ),
    );

    removeUnusedChangedAttributes(newRepeatedBalance);
    removeUnusedChangedAttributes(oldRepeatedBalance);

    isEdited = true;

    data.repeatedBalance.add(newRepeatedBalance);

    return isEdited;
  }

  // TODO: Delete note
  static bool updateOnlyThisOne({
    required BalanceDocument data,
    required String id,
    required Timestamp time,
    required ChangedRepeatedBalanceData changed,
  }) {
    final singleRepeatedBalance = data.repeatedBalance.firstWhereOrNull((element) => element.id == id);
    if (singleRepeatedBalance == null) {
      return false;
    }

    singleRepeatedBalance.changed ??= DateTimeMap();

    singleRepeatedBalance.changed?.addAll({
      time.millisecondsSinceEpoch.toString(): changed
    });
    return true;
  }
}
