//  Single Balance Data Manager - manages all possible interactions with repeated Balances
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:uuid/uuid.dart';

class SingleBalanceDataManager {
  static bool addSingleBalanceToData(
    SingleBalanceData singleBalance,
    BalanceDocument data,
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

    singleBalance.id = const Uuid().v4();
    data.balanceData.add(singleBalance);
    return true;
  }

  /// remove a single Balance and upload it (identified using id)
  static bool removeSingleBalanceFromData(
    String id,
    BalanceDocument data,
  ) {
    final int dataLength = (data.balanceData).length;
    (data.balanceData).removeWhere((value) {
      return value.id == id ||
          value.id == null || // TODO: Check if this is a problem
          value.repeatId != null; // Auto delete trash data
    });
    if (dataLength > data.balanceData.length) {
      return true;
    }

    dev.log("couldn't find the balance with id: $id");
    return false;
  }

  static bool updateSingleBalanceInData(
    String id,
    BalanceDocument data, {
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
    String? name,
    String? note,
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

    for (final value in data.balanceData) {
      if (value.id == id) {
        value.amount = amount ?? value.amount;
        value.category = category ?? value.category;
        value.currency = currency ?? value.currency;
        value.name = name ?? value.name;
        value.note = (deleteNote != null && deleteNote) ? null : note ?? value.note;
        value.time = time ?? value.time;

        // ids are unique
        return true;
      }
    }

    dev.log("couldn't find the balance with id: $id");
    return false;
  }
}
