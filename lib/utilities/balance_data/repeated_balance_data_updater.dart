//  Repeated Balance Data Updater - augments the StreamBuilder Manager with repeatable-specific Elements
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/utilities/backend/date_time_calculation_functions.dart';
import 'package:linum/utilities/backend/repeated_balance_help_functions.dart';
import 'package:uuid/uuid.dart';

class RepeatedBalanceDataUpdater {
  bool updateAll({
    required Map<String, dynamic> data,
    required String id,
    num? amount,
    String? category,
    String? currency,
    Timestamp? endTime,
    Timestamp? initialTime,
    String? name,
    String? note,
    Timestamp? newTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndTime,
    bool? deleteNote,
    Timestamp? time,
  }) {
    bool isEdited = false;
    for (final singleRepeatedBalance
        in data["repeatedBalance"] as List<dynamic>) {
      singleRepeatedBalance as Map<String, dynamic>;
      if (singleRepeatedBalance["id"] == id) {
        if (amount != null) {
          singleRepeatedBalance["amount"] = amount;
          isEdited = true;
        }
        if (category != null && category != singleRepeatedBalance["category"]) {
          singleRepeatedBalance["category"] = category;
          isEdited = true;
        }
        if (currency != null && currency != singleRepeatedBalance["currency"]) {
          singleRepeatedBalance["currency"] = currency;
          isEdited = true;
        }
        if (name != null && name != singleRepeatedBalance["name"]) {
          singleRepeatedBalance["name"] = name;
          isEdited = true;
        }
        if ((note != null && note != singleRepeatedBalance["note"]) ||
            (deleteNote != null && deleteNote)) {
          singleRepeatedBalance["note"] = note;
          isEdited = true;
        }
        if (initialTime != null &&
            initialTime != singleRepeatedBalance["initialTime"]) {
          singleRepeatedBalance["initialTime"] = initialTime;
          isEdited = true;
        } else if (newTime != null && time != null) {
          singleRepeatedBalance["initialTime"] = Timestamp.fromDate(
            (singleRepeatedBalance["initialTime"] as Timestamp)
                .toDate()
                .subtract(
                  time.toDate().difference(newTime.toDate()),
                ),
          );
          if (singleRepeatedBalance["endTime"] != null) {
            singleRepeatedBalance["endTime"] = Timestamp.fromDate(
              (singleRepeatedBalance["endTime"] as Timestamp).toDate().subtract(
                    time.toDate().difference(newTime.toDate()),
                  ),
            );
          }
          isEdited = true;
        }
        if (repeatDuration != null &&
            repeatDuration != singleRepeatedBalance["repeatDuration"]) {
          singleRepeatedBalance["repeatDuration"] = repeatDuration;
          isEdited = true;
        }
        if (repeatDurationType != null &&
            repeatDurationType !=
                EnumToString.fromString<RepeatDurationType>(
                  RepeatDurationType.values,
                  singleRepeatedBalance["repeatDurationType"] as String,
                )) {
          singleRepeatedBalance["repeatDurationType"] =
              repeatDurationType.toString().substring(19);
          isEdited = true;
        }
        if (endTime != null && endTime != singleRepeatedBalance["endTime"]) {
          singleRepeatedBalance["endTime"] = endTime;
          isEdited = true;
        }
        if (resetEndTime != null && resetEndTime) {
          singleRepeatedBalance["endTime"] = null;
          isEdited = true;
        }
        if (initialTime != null ||
            repeatDuration != null ||
            repeatDurationType != null ||
            (newTime != null && time != null)) {
          // FUTURE lazy approach. might think of something clever in the future
          // (what if repeat duration changes. single repeatable changes change time or not? use the nth? complicated...)
          singleRepeatedBalance.remove("changed");
        }

        if (isEdited && singleRepeatedBalance["changed"] != null) {
          (singleRepeatedBalance["changed"] as Map<String, dynamic>)
              .forEach((key, value) {
            if (value != null) {
              if (amount != null) {
                (value as Map<String, dynamic>).remove("amount");
              }
              if (category != null) {
                (value as Map<String, dynamic>).remove("category");
              }
              if (currency != null) {
                (value as Map<String, dynamic>).remove("currency");
              }
              if (name != null) {
                (value as Map<String, dynamic>).remove("name");
              }
              if (newTime != null) {
                (value as Map<String, dynamic>).remove("time");
              }
              // dont need initialTime
              // dont need repeatDuration
              // dont need repeatDurationType
              // dont need endTime
              // dont need resetEndTime,
            }
          });
        }
        return isEdited;
      }
    }
    return false;
  }

  bool updateThisAndAllBefore({
    required Map<String, dynamic> data,
    required String id,
    required Timestamp time,
    num? amount,
    String? category,
    String? currency,
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
    Map<String, dynamic>? newRepeatedBalance;
    for (final oldRepeatedBalance in data["repeatedBalance"] as List<dynamic>) {
      oldRepeatedBalance as Map<String, dynamic>;
      if (oldRepeatedBalance["id"] == id) {
        newRepeatedBalance = oldRepeatedBalance.map((key, value) {
          return MapEntry(key, value);
        });
        newRepeatedBalance["id"] = const Uuid().v4();
        if ((oldRepeatedBalance["repeatDurationType"] as String)
                .toUpperCase() ==
            "MONTHS") {
          oldRepeatedBalance["initialTime"] = Timestamp.fromDate(
            calculateOneTimeStep(
              oldRepeatedBalance["repeatDuration"] as int,
              time.toDate(),
              monthly: true,
              dayOfTheMonth: time.toDate().day,
            ),
          );
        } else {
          oldRepeatedBalance["initialTime"] = Timestamp.fromDate(
            time.toDate().add(
                  Duration(
                    seconds: oldRepeatedBalance["repeatDuration"] as int,
                  ),
                ),
          );
        }
        final Duration timeDifference =
            time.toDate().difference(newTime?.toDate() ?? time.toDate());
        final Map<String, dynamic> changes = <String, dynamic>{
          "amount": amount,
          "category": category,
          "currency": currency,
          "name": name,
          "note": note,
          "initialTime": initialTime ??
              Timestamp.fromDate(
                (newRepeatedBalance["initialTime"] as Timestamp)
                    .toDate()
                    .subtract(timeDifference),
              ),
          "repeatDuration": repeatDuration,
          "repeatDurationType": repeatDurationType?.toString().substring(19),
          "endTime": Timestamp.fromDate(time.toDate().subtract(timeDifference)),
        };
        changes.removeWhere((_, value) => value == null);
        newRepeatedBalance.addAll(changes);

        removeUnusedChangedAttributes(newRepeatedBalance);
        removeUnusedChangedAttributes(oldRepeatedBalance);

        isEdited = true;
      }
    }
    (data["repeatedBalance"] as List<dynamic>).add(newRepeatedBalance);

    return isEdited;
  }

  bool updateThisAndAllAfter({
    required Map<String, dynamic> data,
    required String id,
    required Timestamp time,
    num? amount,
    String? category,
    String? currency,
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
    Map<String, dynamic>? newRepeatedBalance;
    for (final oldRepeatedBalance in data["repeatedBalance"] as List<dynamic>) {
      oldRepeatedBalance as Map<String, dynamic>;
      if (oldRepeatedBalance["id"] == id) {
        newRepeatedBalance = oldRepeatedBalance.map((key, value) {
          return MapEntry(key, value);
        });
        newRepeatedBalance["id"] = const Uuid().v4();
        if ((oldRepeatedBalance["repeatDurationType"] as String)
                .toUpperCase() ==
            "MONTHS") {
          oldRepeatedBalance["endTime"] = Timestamp.fromDate(
            calculateOneTimeStepBackwards(
              oldRepeatedBalance["repeatDuration"] as int,
              time.toDate(),
              monthly: true,
              dayOfTheMonth: time.toDate().day,
            ),
          );
        } else {
          oldRepeatedBalance["endTime"] = Timestamp.fromDate(
            time.toDate().subtract(
                  Duration(
                    seconds: oldRepeatedBalance["repeatDuration"] as int,
                  ),
                ),
          );
        }
        final Duration timeDifference =
            time.toDate().difference(newTime?.toDate() ?? time.toDate());
        final Map<String, dynamic> changes = <String, dynamic>{
          "amount": amount,
          "category": category,
          "currency": currency,
          "name": name,
          "note": note,
          "initialTime":
              Timestamp.fromDate(time.toDate().subtract(timeDifference)),
          "repeatDuration": repeatDuration,
          "repeatDurationType": repeatDurationType?.toString().substring(19),
          "endTime": changeThisAndAllAfterEndTimeHelpFunction(
            endTime,
            newRepeatedBalance,
            timeDifference,
          ),
        };
        changes.removeWhere((_, value) => value == null);
        newRepeatedBalance.addAll(changes);

        removeUnusedChangedAttributes(newRepeatedBalance);
        removeUnusedChangedAttributes(oldRepeatedBalance);

        isEdited = true;
      }
    }
    (data["repeatedBalance"] as List<dynamic>).add(newRepeatedBalance);

    return isEdited;
  }

  bool updateOnlyThisOne({
    required Map<String, dynamic> data,
    required String id,
    required Timestamp time,
    num? amount,
    String? category,
    String? currency,
    String? name,
    Timestamp? newTime,
    String? note,
  }) {
    for (final singleRepeatedBalance
        in data["repeatedBalance"] as List<dynamic>) {
      singleRepeatedBalance as Map<String, dynamic>;
      if (singleRepeatedBalance["id"] == id) {
        if (singleRepeatedBalance["changed"] == null) {
          singleRepeatedBalance["changed"] = <String, Map<String, dynamic>>{};
        }
        final Map<String, Map<String, dynamic>> newChanged =
            <String, Map<String, dynamic>>{};
        // ignore: avoid_dynamic_calls
        singleRepeatedBalance["changed"].forEach((outerKey, innerMap) {
          newChanged[outerKey as String] = <String, dynamic>{};
          // ignore: avoid_dynamic_calls
          innerMap.forEach(
            (innerKey, innerValue) {
              newChanged[outerKey]![innerKey as String] = innerValue;
            },
          );
        });

        newChanged.addAll({
          time.millisecondsSinceEpoch.toString(): {
            "amount": amount,
            "category": category,
            "currency": currency,
            "name": name,
            "note": note,
            "time": newTime,
          }
        });
        newChanged[time.millisecondsSinceEpoch.toString()]
            ?.removeWhere((_, value) => value == null);
        singleRepeatedBalance["changed"] = newChanged;
        return true;
      }
    }
    return false;
  }
}
