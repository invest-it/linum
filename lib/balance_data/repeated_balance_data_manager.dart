import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/backend_functions/date_time_calculation_functions.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:uuid/uuid.dart';

class RepeatedBalanceDataManager {
  /// add a repeated Balance and upload it (the stream will automatically show it in the app again)
  bool addRepeatedBalance(
    RepeatBalanceData repeatBalanceData,
    Map<String, dynamic> data,
  ) {
    if (repeatBalanceData.category == "" || repeatBalanceData.currency == "") {
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

  bool isMonthly(Map<String, dynamic> singleRepeatedBalance) {
    return singleRepeatedBalance["repeatDurationType"] != null &&
        (singleRepeatedBalance["repeatDurationType"] as String).toUpperCase() ==
            "MONTHS";
  }

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
}
