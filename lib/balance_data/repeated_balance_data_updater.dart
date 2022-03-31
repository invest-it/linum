import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:linum/models/repeat_duration_type_enum.dart';
import 'package:linum/models/repeatable_change_type.dart';
import 'package:uuid/uuid.dart';

class RepeatedBalanceDataUpdater {
  bool updateAll({
    required RepeatableChangeType changeType,
    required Map<String, dynamic> data,
    required String id,
    num? amount,
    String? category,
    String? currency,
    Timestamp? endTime,
    Timestamp? initialTime,
    String? name,
    Timestamp? newTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndTime,
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
          singleRepeatedBalance["repeatDuration"] =
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
    required RepeatableChangeType changeType,
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
            DateTime(
              time.toDate().year,
              time.toDate().month +
                  (oldRepeatedBalance["repeatDuration"] as int),
              time.toDate().day,
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
          "initialTime": initialTime ??
              Timestamp.fromDate(
                (newRepeatedBalance["initialTime"] as Timestamp)
                    .toDate()
                    .subtract(timeDifference),
              ),
          "repeatDuration": repeatDuration,
          "repeatDurationType": repeatDurationType,
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
    required RepeatableChangeType changeType,
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
            DateTime(
              time.toDate().year,
              time.toDate().month -
                  (oldRepeatedBalance["repeatDuration"] as int),
              time.toDate().day,
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
          "initialTime":
              Timestamp.fromDate(time.toDate().subtract(timeDifference)),
          "repeatDuration": repeatDuration,
          "repeatDurationType": repeatDurationType,
          "endTime": _changeThisAndAllAfterEndTimeHelpFunction(
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
    required RepeatableChangeType changeType,
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
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndTime,
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

  // Helpfunctions

  /// after splitting a repeatable delete copied "changes" attributes that are out of the time limits of that repeatable
  void removeUnusedChangedAttributes(
    Map<String, dynamic> singleRepeatedBalance,
  ) {
    if (singleRepeatedBalance["changes"] == null) {
      return;
    }
    final List<String> keysToRemove = <String>[];
    for (final timeStampString
        in (singleRepeatedBalance["changes"] as Map<String, dynamic>).keys) {
      if (!DateTime.fromMillisecondsSinceEpoch(
            (num.tryParse(timeStampString) as int?) ?? 0,
          ).isBefore(
            (singleRepeatedBalance["initialTime"] as Timestamp).toDate(),
          ) &&
          !DateTime.fromMillisecondsSinceEpoch(
            (num.tryParse(timeStampString) as int?) ?? 0,
          ).isAfter(
            (singleRepeatedBalance["endTime"] as Timestamp).toDate(),
          )) {
        keysToRemove.add(timeStampString);
      }
    }
    for (final key in keysToRemove) {
      (singleRepeatedBalance["changes"] as Map<String, dynamic>).remove(key);
    }
  }

  Timestamp? _changeThisAndAllAfterEndTimeHelpFunction(
    Timestamp? checkedEndTime,
    Map<String, dynamic> newRepeatedBalance,
    Duration timeDifference,
  ) {
    if (checkedEndTime != null) {
      return checkedEndTime;
    }
    if (newRepeatedBalance["endTime"] != null) {
      return Timestamp.fromDate(
        (newRepeatedBalance["endTime"] as Timestamp)
            .toDate()
            .subtract(timeDifference),
      );
    } else {
      return null;
    }
  }
}
