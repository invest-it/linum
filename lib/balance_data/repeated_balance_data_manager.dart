import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:linum/balance_data/repeated_balance_data_remover.dart';
import 'package:linum/balance_data/repeated_balance_data_updater.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/repeat_duration_type_enum.dart';
import 'package:linum/models/repeatable_change_type.dart';
import 'package:linum/utilities/backend/date_time_calculation_functions.dart';
import 'package:linum/utilities/backend/repeated_balance_help_functions.dart';
import 'package:uuid/uuid.dart';

class RepeatedBalanceDataManager {
  late final RepeatedBalanceDataUpdater repeatedBalanceDataUpdater;
  late final RepeatedBalanceDataRemover repeatedBalanceDataRemover;

  RepeatedBalanceDataManager() {
    repeatedBalanceDataUpdater = RepeatedBalanceDataUpdater();
    repeatedBalanceDataRemover = RepeatedBalanceDataRemover();
  }

  /// add a repeated Balance and upload it (the stream will automatically show it in the app again)
  bool addRepeatedBalanceToData(
    RepeatedBalanceData repeatBalanceData,
    Map<String, dynamic> data,
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

    final Map<String, dynamic> singleRepeatedBalance = {
      "amount": repeatBalanceData.amount,
      "category": repeatBalanceData.category,
      "currency": repeatBalanceData.currency,
      "name": repeatBalanceData.name,
      "initialTime": repeatBalanceData.initialTime,
      "repeatDuration": repeatBalanceData.repeatDuration,
      "repeatDurationType":
          repeatBalanceData.repeatDurationType.toString().substring(19),
      "endTime": repeatBalanceData.endTime,
      "id": const Uuid().v4(),
    };
    (data["repeatedBalance"] as List<dynamic>).add(singleRepeatedBalance);
    return true;
  }

  bool updateRepeatedBalanceInData({
    required RepeatableChangeType changeType,
    required String id,
    required Map<String, dynamic> data,
    num? amount,
    String? category,
    String? currency,
    String? name,
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
    Timestamp? checkedInitialTime;
    int? checkedRepeatDuration;
    RepeatDurationType? checkedRepeatDurationType;
    Timestamp? checkedEndTime;
    Timestamp? checkedNewTime;

    for (final singleRepeatedBalance
        in data["repeatedBalance"] as List<dynamic>) {
      singleRepeatedBalance as Map<String, dynamic>;
      if (singleRepeatedBalance["id"] == id) {
        if (amount != singleRepeatedBalance["amount"]) {
          checkedAmount = amount;
        }
        if (category != singleRepeatedBalance["category"]) {
          checkedCategory = category;
        }
        if (currency != singleRepeatedBalance["currency"]) {
          checkedCurrency = currency;
        }
        if (name != singleRepeatedBalance["name"]) {
          checkedName = name;
        }
        if (initialTime != singleRepeatedBalance["initialTime"]) {
          checkedInitialTime = initialTime;
        }
        if (repeatDuration != singleRepeatedBalance["repeatDuration"]) {
          checkedRepeatDuration = repeatDuration;
        }
        if (repeatDurationType !=
            EnumToString.fromString<RepeatDurationType>(
              RepeatDurationType.values,
              singleRepeatedBalance["repeatDurationType"] as String,
            )) {
          checkedRepeatDurationType = repeatDurationType;
        }
        if (endTime != singleRepeatedBalance["endTime"]) {
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
        return repeatedBalanceDataUpdater.updateAll(
          amount: checkedAmount,
          category: checkedCategory,
          currency: checkedCurrency,
          data: data,
          endTime: checkedEndTime,
          id: id,
          initialTime: checkedInitialTime,
          name: checkedName,
          newTime: checkedNewTime,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndTime: resetEndTime,
          time: time,
        );
      case RepeatableChangeType.thisAndAllBefore:
        return repeatedBalanceDataUpdater.updateThisAndAllBefore(
          amount: checkedAmount,
          category: checkedCategory,
          currency: checkedCurrency,
          data: data,
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
      case RepeatableChangeType.thisAndAllAfter:
        return repeatedBalanceDataUpdater.updateThisAndAllAfter(
          amount: checkedAmount,
          category: checkedCategory,
          currency: checkedCurrency,
          data: data,
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
        return repeatedBalanceDataUpdater.updateOnlyThisOne(
          amount: checkedAmount,
          category: checkedCategory,
          currency: checkedCurrency,
          data: data,
          id: id,
          name: checkedName,
          newTime: checkedNewTime,
          time: time!,
        );
    }
  }

  bool removeRepeatedBalanceFromData({
    required String id,
    required Map<String, dynamic> data,
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
        return repeatedBalanceDataRemover.removeAll(data, id);
      case RepeatableChangeType.thisAndAllBefore:
        return repeatedBalanceDataRemover.removeThisAndAllBefore(
          data,
          id,
          time!,
        );
      case RepeatableChangeType.thisAndAllAfter:
        return repeatedBalanceDataRemover.removeThisAndAllAfter(
          data,
          id,
          time!,
        );
      case RepeatableChangeType.onlyThisOne:
        return repeatedBalanceDataRemover.removeOnlyThisOne(data, id, time!);
    }
  }

  // Local Data generation

  /// goes trough the repeatable list and uses addSingleRepeatableToBalanceDataLocally
  void addAllRepeatablesToBalanceDataLocally(
    List<Map<String, dynamic>> repeatedBalance,
    List<Map<String, dynamic>> balanceData,
  ) {
    for (final singleRepeatedBalance in repeatedBalance) {
      addSingleRepeatableToBalanceDataLocally(
        singleRepeatedBalance,
        balanceData,
      );
    }
  }

  /// adds a repeatable for the whole needed duration up to one year with all needed "changes" into the balancedata
  void addSingleRepeatableToBalanceDataLocally(
    Map<String, dynamic> singleRepeatedBalance,
    List<Map<String, dynamic>> balanceData,
  ) {
    DateTime currentTime =
        (singleRepeatedBalance["initialTime"] as Timestamp).toDate();

    const Duration futureDuration = Duration(days: 365);

    // while we are before 1 years after today / before endTime
    while ((singleRepeatedBalance["endTime"] != null)
        // !isbefore => currentime = endtime = true
        ? !(singleRepeatedBalance["endTime"] as Timestamp).toDate().isBefore(
              currentTime,
            )
        : DateTime.now().add(futureDuration).isAfter(currentTime)) {
      // if "changed" -> "this timestamp" -> deleted exist AND it is true, dont add this balance
      if (singleRepeatedBalance["changed"] == null ||
          (singleRepeatedBalance["changed"] as Map<String, dynamic>)[
                  Timestamp.fromDate(currentTime)
                      .millisecondsSinceEpoch
                      .toString()] ==
              null ||
          ((singleRepeatedBalance["changed"] as Map<String, dynamic>)[
                  Timestamp.fromDate(currentTime)
                      .millisecondsSinceEpoch
                      .toString()] as Map<String, dynamic>)["deleted"] ==
              null ||
          !(((singleRepeatedBalance["changed"]
                  as Map<String, dynamic>)[Timestamp.fromDate(currentTime).millisecondsSinceEpoch.toString()]
              as Map<String, dynamic>)["deleted"] as bool)) {
        balanceData.add({
          "amount":
              ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                      Timestamp.fromDate(currentTime)
                          .millisecondsSinceEpoch
                          .toString()] as Map<String, dynamic>?)?["amount"] ??
                  singleRepeatedBalance["amount"],
          "category":
              ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                      Timestamp.fromDate(currentTime)
                          .millisecondsSinceEpoch
                          .toString()] as Map<String, dynamic>?)?["category"] ??
                  singleRepeatedBalance["category"],
          "currency":
              ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                      Timestamp.fromDate(currentTime)
                          .millisecondsSinceEpoch
                          .toString()] as Map<String, dynamic>?)?["currency"] ??
                  singleRepeatedBalance["currency"],
          "name": ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                  Timestamp.fromDate(currentTime)
                      .millisecondsSinceEpoch
                      .toString()] as Map<String, dynamic>?)?["name"] ??
              singleRepeatedBalance["name"],
          "time": ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                  Timestamp.fromDate(currentTime)
                      .millisecondsSinceEpoch
                      .toString()] as Map<String, dynamic>?)?["time"] ??
              Timestamp.fromDate(currentTime),
          "repeatId": singleRepeatedBalance["id"],
          "id": const Uuid().v4(),
        });
        if (((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                Timestamp.fromDate(currentTime)
                    .millisecondsSinceEpoch
                    .toString()] as Map<String, dynamic>?)?["time"] !=
            null) {
          balanceData.last["formerTime"] = Timestamp.fromDate(currentTime);
        }
      }
      currentTime = calculateOneTimeStep(
        singleRepeatedBalance["repeatDuration"] as int,
        currentTime,
        // is it a month or second duration type
        monthly: isMonthly(singleRepeatedBalance),
        dayOfTheMonth:
            (singleRepeatedBalance["initialTime"] as Timestamp).toDate().day,
      );
    }
  }
}
