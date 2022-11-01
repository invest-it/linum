//  Single Balance Data Manager - manages all possible interactions with repeated Balances
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/transaction.dart';

class TransactionManager {
  static bool addTransactionToData(
    Transaction transaction,
    BalanceDocument data,
  ) {
    // conditions
    if (transaction.category == "") {
      dev.log("transaction.category must be != '' ");
      return false;
    }
    if (transaction.currency == "") {
      dev.log("transaction.currency must be != '' ");
      return false;
    }

    data.transactions.add(transaction);
    return true;
  }

  /// remove a single Balance and upload it (identified using id)
  static bool removeTransactionFromData(
    String id,
    BalanceDocument data,
  ) {
    final int dataLength = (data.transactions).length;
    (data.transactions).removeWhere((value) {
      return value.id == id || value.repeatId != null; // Auto delete trash data
    });
    if (dataLength > data.transactions.length) {
      return true;
    }

    dev.log("couldn't find the balance with id: $id");
    return false;
  }

  static bool updateTransactionInData(
    String id,
    BalanceDocument data, {
    num? amount,
    String? category,
    String? currency,
    bool? deleteNote,
    String? name,
    String? note,
    firestore.Timestamp? time,
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

    final transactionIndex = data.transactions.indexWhere((trans) => trans.id == id);
    if (transactionIndex == -1) {
      dev.log("couldn't find the balance with id: $id");
      return false;
    }
    final transaction = data.transactions[transactionIndex];

    final updatedTransaction = transaction.copyWith(
      amount: amount ?? transaction.amount,
      category: category ?? transaction.category,
      currency: currency ?? transaction.currency,
      name: name ?? transaction.name,
      note: (deleteNote != null && deleteNote) ? null : note ?? transaction.note,
      time: time ?? transaction.time,
    );

    data.transactions[transactionIndex] = updatedTransaction;

    return true;

  }
}
