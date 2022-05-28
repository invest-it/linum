//  Single Balance Data Manager - augments the StreamBuilder Manager with single-transactions-specific Elements
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:uuid/uuid.dart';

class SingleBalanceDataManager {
  bool addSingleBalanceToData(
    SingleBalanceData singleBalance,
    Map<String, dynamic> data,
  ) {
    // conditions
    if (singleBalance.category == "") {
      dev.log("singleBalance.category must be != '' ");
      return false;
    }
    if (singleBalance.currency == "") {
      dev.log("singleBalance.currency must be != '' ");
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

    dev.log("couldn't find the balance with id: $id");
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
    // conditions
    if (id == "") {
      dev.log("no id provided");
      return false;
    }
    if (category == "") {
      dev.log("category must be != '' ");
      return false;
    }
    if (currency == "") {
      dev.log("currency must be != '' ");
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

    dev.log("couldn't find the balance with id: $id");
    return false;
  }
}
