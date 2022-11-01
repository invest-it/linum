//  Repeated Balance Data Manager - manages all possible interactions with repeated Balances
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/constants/repeatable_change_type_enum.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/changed_repeated_balance.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/utilities/backend/date_time_calculation_functions.dart';
import 'package:linum/utilities/backend/repeated_balance_help_functions.dart';
import 'package:linum/utilities/balance_data/repeated_balance_data_remover.dart';
import 'package:linum/utilities/balance_data/repeated_balance_data_updater.dart';
import 'package:uuid/uuid.dart';

class RepeatedBalanceDataManager {
  /// add a repeated Balance and upload it (the stream will automatically show it in the app again)
  static bool addRepeatedBalanceToData(
    RepeatedBalanceData repeatBalanceData,
    BalanceDocument data,
  ) {
    // conditions
    if (repeatBalanceData.category == "") {
      dev.log("repeatBalanceData.category must be != '' ");
      return false;
    }
    if (repeatBalanceData.currency == "") {
      dev.log("repeatBalanceData.currency must be != '' ");
      return false;
    }

    repeatBalanceData.id = const Uuid().v4();

    data.repeatedBalance.add(repeatBalanceData);
    return true;
  }

  static bool updateRepeatedBalanceInData({
    required RepeatableChangeType changeType,
    required String id,
    required BalanceDocument data,
    num? amount,
    String? category,
    String? currency,
    String? name,
    String? note,
    bool? deleteNote,
    Timestamp? initialTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    Timestamp? endTime,
    bool? resetEndTime,
    Timestamp? time,
    Timestamp? newTime,
  }) {
    // conditions
    if (id == "") {
      dev.log("no id provided");
      return false;
    }
    if (changeType == RepeatableChangeType.thisAndAllBefore) {
      if (time == null) {
        dev.log("RepeatableChangeType.thisAndAllBefore => time != null");
        return false;
      }
      if (resetEndTime ?? false || endTime != null) {
        dev.log(
          "resetEndTime, endTime are no available for RepeatableChangeType.thisAndAllBefore",
        );
        return false;
      }
    }
    if (changeType == RepeatableChangeType.thisAndAllAfter) {
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
    if (changeType == RepeatableChangeType.onlyThisOne) {
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
    Timestamp? checkedInitialTime;
    int? checkedRepeatDuration;
    RepeatDurationType? checkedRepeatDurationType;
    Timestamp? checkedEndTime;
    Timestamp? checkedNewTime;

    for (final singleRepeatedBalance
        in data.repeatedBalance) {
      if (singleRepeatedBalance.id == id) {
        if (amount != singleRepeatedBalance.amount) {
          checkedAmount = amount;
        }
        if (category != singleRepeatedBalance.category) {
          checkedCategory = category;
        }
        if (currency != singleRepeatedBalance.currency) {
          checkedCurrency = currency;
        }
        if (name != singleRepeatedBalance.name) {
          checkedName = name;
        }
        if (note != singleRepeatedBalance.note) {
          checkedNote = note;
        }
        if (initialTime != singleRepeatedBalance.initialTime) {
          checkedInitialTime = initialTime;
        }
        if (repeatDuration != singleRepeatedBalance.repeatDuration) {
          checkedRepeatDuration = repeatDuration;
        }
        if (repeatDurationType != singleRepeatedBalance.repeatDurationType) {
          checkedRepeatDurationType = repeatDurationType;
        }
        if (endTime != singleRepeatedBalance.endTime) {
          checkedEndTime = endTime;
        }
        if (newTime != time) {
          checkedNewTime = newTime;
        }

        break;
      }
    }

    switch (changeType) {
      case RepeatableChangeType.all:
        return RepeatedBalanceDataUpdater.updateAll(
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
      case RepeatableChangeType.thisAndAllBefore:
        return RepeatedBalanceDataUpdater.updateThisAndAllBefore(
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
      case RepeatableChangeType.thisAndAllAfter:
        return RepeatedBalanceDataUpdater.updateThisAndAllAfter(
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

      case RepeatableChangeType.onlyThisOne:
        return RepeatedBalanceDataUpdater.updateOnlyThisOne(
          data: data,
          id: id,
          time: time!,
          changed: ChangedRepeatedBalanceData(
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

 static bool removeRepeatedBalanceFromData({
    required String id,
    required BalanceDocument data,
    required RepeatableChangeType removeType,
    Timestamp? time,
  }) {
    // conditions
    if (removeType == RepeatableChangeType.thisAndAllBefore && time == null) {
      dev.log(
        "removeType == RepeatableChangeType.thisAndAllBefore => time != null",
      );
      return false;
    }
    if (removeType == RepeatableChangeType.thisAndAllAfter && time == null) {
      dev.log(
        "removeType == RepeatableChangeType.thisAndAllAfter => time != null",
      );
      return false;
    }
    if (removeType == RepeatableChangeType.onlyThisOne && time == null) {
      dev.log("removeType == RepeatableChangeType.onlyThisOne => time != null");
      return false;
    }

    switch (removeType) {
      case RepeatableChangeType.all:
        return RepeatedBalanceDataRemover.removeAll(data, id);
      case RepeatableChangeType.thisAndAllBefore:
        return RepeatedBalanceDataRemover.removeThisAndAllBefore(
          data,
          id,
          time!,
        );
      case RepeatableChangeType.thisAndAllAfter:
        return RepeatedBalanceDataRemover.removeThisAndAllAfter(
          data,
          id,
          time!,
        );
      case RepeatableChangeType.onlyThisOne:
        return RepeatedBalanceDataRemover.removeOnlyThisOne(data, id, time!);
    }
  }

  // Local Data generation

  /// goes trough the repeatable list and uses addSingleRepeatableToBalanceDataLocally
  /// TODO: DOC: WHY DOES IT DO THAT?
  static void addAllRepeatablesToBalanceDataLocally(
    List<RepeatedBalanceData> repeatedBalance,
    List<SingleBalanceData> balanceData,
  ) {
    for (final singleRepeatedBalance in repeatedBalance) {
      addSingleRepeatableToBalanceDataLocally(
        singleRepeatedBalance,
        balanceData,
      );
    }
  }

  /// adds a repeatable for the whole needed duration up to one year with all needed "changes" into the balancedata
  static void addSingleRepeatableToBalanceDataLocally(
    RepeatedBalanceData singleRepeatedBalance,
    List<SingleBalanceData> balanceData,
  ) {
    DateTime currentTime =
        singleRepeatedBalance.initialTime.toDate();

    const Duration futureDuration = Duration(days: 365);

    // while we are before 1 years after today / before endTime
    while ((singleRepeatedBalance.endTime != null)
        // !isbefore => currentime = endtime = true
        ? !singleRepeatedBalance.endTime!.toDate().isBefore(currentTime)
        : DateTime.now().add(futureDuration).isAfter(currentTime)) {
      // if "changed" -> "this timestamp" -> deleted exist AND it is true, dont add this balance
      if (singleRepeatedBalance.changed == null
          || singleRepeatedBalance.changed![currentTime] == null
          || singleRepeatedBalance.changed![currentTime]!.deleted == null
          || !singleRepeatedBalance.changed![currentTime]!.deleted!) {
        balanceData.add(
            SingleBalanceData(
              amount: singleRepeatedBalance.changed?[currentTime]?.amount
                  ?? singleRepeatedBalance.amount,
              category: singleRepeatedBalance.changed?[currentTime]?.category ??
                  singleRepeatedBalance.category,
              currency: singleRepeatedBalance.changed?[currentTime]?.currency ??
                  singleRepeatedBalance.currency,
              name: singleRepeatedBalance.changed?[currentTime]?.name ??
                  singleRepeatedBalance.name,
              time: singleRepeatedBalance.changed?[currentTime]?.time ??
                  Timestamp.fromDate(currentTime),
              repeatId: singleRepeatedBalance.id,
              id: const Uuid().v4(),
              formerTime: (singleRepeatedBalance.changed?[currentTime]?.time != null)
                  ? Timestamp.fromDate(currentTime) : null,
            ),
        );
      }
      currentTime = calculateOneTimeStep(
        singleRepeatedBalance.repeatDuration,
        currentTime,
        // is it a month or second duration type
        monthly: isMonthly(singleRepeatedBalance),
        dayOfTheMonth: singleRepeatedBalance.initialTime.toDate().day,
      );
    }
  }
}
