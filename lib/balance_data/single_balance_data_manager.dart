import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:uuid/uuid.dart';

class SingleBalanceDataManager {
  bool addSingleBalanceToData(
    SingleBalanceData singleBalance,
    Map<String, dynamic> data,
  ) {
    if (singleBalance.category == "" || singleBalance.currency == "") {
      return false;
    }
    final Map<String, dynamic> singleBalanceMap = {
      "amount": singleBalance.amount,
      "category": singleBalance.category,
      "currency": singleBalance.currency,
      "name": singleBalance.name,
      "time": singleBalance.time,
      "id": const Uuid().v4(),
    };
    (data["balanceData"] as List<dynamic>).add(singleBalanceMap);
    return true;
  }

  /// remove a single Balance and upload it (identified using id)
  bool removeSingleBalanceFromData(
    String id,
    Map<String, dynamic> data,
  ) {
    final int dataLength = (data["balanceData"] as List<dynamic>).length;
    (data["balanceData"] as List<dynamic>).removeWhere((value) {
      return (value as Map<String, dynamic>)["id"] == id ||
          value["id"] == null ||
          value["repeatId"] != null; // Auto delete trash data
    });
    if (dataLength > (data["balanceData"] as List<dynamic>).length) {
      return true;
    }
    return false;
  }

  bool updateSingleBalanceInData(
    String id,
    Map<String, dynamic> data, {
    num? amount,
    String? category,
    String? currency,
    String? name,
    Timestamp? time,
  }) {
    if (id == "") {
      dev.log("no id provided");
      return false;
    }
    for (final value in data["balanceData"] as List<dynamic>) {
      if ((value as Map<String, dynamic>)["id"] == id) {
        value["amount"] = amount ?? value["amount"];
        value["category"] = category ?? value["category"];
        value["currency"] = currency ?? value["currency"];
        value["name"] = name ?? value["name"];
        value["time"] = time ?? value["time"];

        // ids are unique
        return true;
      }
    }

    return false;
  }
}
