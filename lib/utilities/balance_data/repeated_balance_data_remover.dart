import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';

class RepeatedBalanceDataRemover {
  bool removeAll(Map<String, dynamic> data, String id) {
    final int length = (data["repeatedBalance"] as List<dynamic>).length;
    (data["repeatedBalance"] as List<dynamic>).removeWhere((element) {
      return (element as Map<String, dynamic>)["id"] == id;
    });
    if (length == (data["repeatedBalance"] as List<dynamic>).length) {
      dev.log("The repeatable balance wasn't found");
      return false;
    }
    return true;
  }

  bool removeThisAndAllBefore(
    Map<String, dynamic> data,
    String id,
    Timestamp time,
  ) {
    for (final Map<String, dynamic> singleRepeatedBalance
        in data["repeatedBalance"]) {
      if (singleRepeatedBalance["id"] == id) {
        if ((singleRepeatedBalance["repeatDurationType"] as String)
                .toUpperCase() ==
            "MONTHS") {
          singleRepeatedBalance["initialTime"] = Timestamp.fromDate(
            DateTime(
              time.toDate().year,
              time.toDate().month +
                  (singleRepeatedBalance["repeatDuration"] as int),
              time.toDate().day,
            ),
          );
        } else {
          // if not month => seconds
          singleRepeatedBalance["initialTime"] = Timestamp.fromDate(
            time.toDate().add(
                  Duration(
                    seconds: singleRepeatedBalance["repeatDuration"] as int,
                  ),
                ),
          );
        }

        return true;
      }
    }
    return false;
  }

  bool removeThisAndAllAfter(
    Map<String, dynamic> data,
    String id,
    Timestamp time,
  ) {
    for (final Map<String, dynamic> singleRepeatedBalance
        in data["repeatedBalance"]) {
      if (singleRepeatedBalance["id"] == id) {
        if ((singleRepeatedBalance["repeatDurationType"] as String)
                .toUpperCase() ==
            "MONTHS") {
          singleRepeatedBalance["endTime"] = Timestamp.fromDate(
            DateTime(
              time.toDate().year,
              time.toDate().month -
                  (singleRepeatedBalance["repeatDuration"] as int),
              time.toDate().day,
            ),
          );
        } else {
          // if not month => seconds
          singleRepeatedBalance["endTime"] = Timestamp.fromDate(
            time.toDate().subtract(
                  Duration(
                    seconds: singleRepeatedBalance["repeatDuration"] as int,
                  ),
                ),
          );
        }
        return true;
      }
    }
    return false;
  }

  bool removeOnlyThisOne(
    Map<String, dynamic> data,
    String id,
    Timestamp time,
  ) {
    for (final Map<String, dynamic> singleRepeatedBalance
        in data["repeatedBalance"]) {
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
            "deleted": true,
          }
        });
        singleRepeatedBalance["changed"] = newChanged;

        return true;
      }
    }

    return false;
  }
}
