//  Single Balance Data Manager - manages all possible interactions with repeated Balances
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (refactored)

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:logger/logger.dart';

class TransactionManager {
  static final Logger logger = Logger();

  static bool addTransactionToData(
    Transaction transaction,
    BalanceDocument data,
  ) {
    // conditions
    if (transaction.category == "") {
      logger.e("transaction.category must be != '' ");
      return false;
    }
    if (transaction.currency == "") {
      logger.e("transaction.currency must be != '' ");
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
    final int dataLength = data.transactions.length;
    data.transactions.removeWhere((value) {
      return value.id == id; // Auto delete trash data
    });
    if (dataLength > data.transactions.length) {
      return true;
    }

    logger.e("couldn't find the balance with id: $id");
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
      logger.e("no id provided");
      return false;
    }
    if (category == "") {
      logger.e("category must be != '' ");
      return false;
    }
    if (currency == "") {
      logger.e("currency must be != '' ");
      return false;
    }
    print(data.transactions);
    final transactionIndex =
        data.transactions.indexWhere((trans) => trans.id == id);
    if (transactionIndex == -1) {
      logger.e("couldn't find the balance with id: $id");
      return false;
    }
    final transaction = data.transactions[transactionIndex];

    final updatedTransaction = transaction.copyWith(
      amount: amount ?? transaction.amount,
      category: category ?? transaction.category,
      currency: currency ?? transaction.currency,
      name: name ?? transaction.name,
      note:
          (deleteNote != null && deleteNote) ? null : note ?? transaction.note,
      time: time ?? transaction.time,
    );

    data.transactions[transactionIndex] = updatedTransaction;

    return true;
  }
}
