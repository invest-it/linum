import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/cupertino.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/repositories/balance_data_repository.dart';
import 'package:linum/core/balance/utils/serial_transaction_manager.dart';
import 'package:linum/core/balance/utils/transaction_manager.dart';
import 'package:logger/logger.dart';

class BalanceDataService extends ChangeNotifier {
  final String userId;

  BalanceDataService(this.userId) {
    print(userId);
    _repository = BalanceDataRepository(userId: userId);
  }

  late BalanceDataRepository _repository;

  Stream <DocumentSnapshot<BalanceDocument>>? get stream
    => _repository.stream;

  /// add a single Balance and upload it
  Future<bool> addTransaction(Transaction transaction) async {
    return _repository.balanceDocument.asyncMap((data) async {
      if (data == null) {
        return false;
      }

      if (TransactionManager.addTransactionToData(transaction, data)) {
        await _repository.set(data);
        return true;
      }

      Logger().e("couldn't add single balance");
      return false;
    }).first;
  }

  /// update a single Balance and upload it (identified using the name and time)
  Future<bool> updateTransactionDirectly({
    required String id,
    num? amount,
    String? category,
    String? currency,
    String? name,
    Timestamp? date,
    String? note,
  }) async {
    return _repository.balanceDocument.asyncMap((data) async {
      if (data == null) {
        return false;
      }

      // update and upload
      if (TransactionManager.updateTransactionInData(
        id,
        data,
        amount: amount,
        category: category,
        currency: currency,
        name: name,
        date: date,
        note: note,
      )) {
        await _repository.set(data);
        return true;
      }

      await _repository
          .update(data.toMap());
      return true;
    }).first;
  }

  Future<bool> updateTransaction(
      Transaction transaction,
      ) async {
    return updateTransactionDirectly(
      id: transaction.id,
      amount: transaction.amount,
      category: transaction.category,
      currency: transaction.currency,
      name: transaction.name,
      date: transaction.date,
      note: transaction.note,
    );
  }

  /// remove a single Balance and upload it (identified using id)
  Future<bool> removeTransactionUsingId(String id) async {
    return _repository.balanceDocument.asyncMap((data) async {
      if (data == null) {
        return false;
      }

      // remove and upload
      if (TransactionManager.removeTransactionFromData(id, data)) {
        await _repository.set(data);
        return true;
      }

      Logger().e("couldn't remove single balance");
      return false;
    }).first;
  }

  /// it is an alias for removeSingleBalanceUsingId(singleBalance.id);
  Future<bool> removeTransaction(Transaction transaction) {
    return removeTransactionUsingId(transaction.id);
  }

  Future<SerialTransaction?> findSerialTransactionWithId(String id) async {
    final serialTransaction = _repository.balanceDocument.map((event) {
      return event?.serialTransactions.firstWhere((element) => element.id == id);
    });
    return serialTransaction.first;
  }

  Future<bool> addSerialTransaction(
    SerialTransaction serialTransaction,
  ) async {
    return _repository.balanceDocument.asyncMap((data) async {
      if (data == null) {
        return false;
      }
      if (SerialTransactionManager.addSerialTransactionToData(
          serialTransaction,
          data,
      )) {
        await _repository.set(data);
        return true;
      }
      return false;
    }).first;
  }

  Future<bool> updateSerialTransaction({
    required SerialTransaction serialTransaction,
    required SerialTransactionChangeMode changeMode,
     Timestamp? oldDate,
     Timestamp? newDate,
    bool resetEndDate = false,
  }) async {
    return _repository.balanceDocument.asyncMap((data) async {
      if (data == null) {
        return false;
      }
      if (SerialTransactionManager.updateSerialTransactionInData(
        id: serialTransaction.id,
        changeType: changeMode,
        data: data,
        amount: serialTransaction.amount,
        category: serialTransaction.category,
        currency: serialTransaction.currency,
        name: serialTransaction.name,
        startDate: serialTransaction.startDate,
        repeatDuration: serialTransaction.repeatDuration,
        repeatDurationType: serialTransaction.repeatDurationType,
        endDate: serialTransaction.endDate,
        resetEndDate: resetEndDate,
        oldDate: oldDate,
        newDate: newDate,
        note: serialTransaction.note,
      )) {
        await _repository.set(data);
        return true;
      }

      return false;
    }).first;
  }

  Future<bool> removeSerialTransaction({
    required SerialTransaction serialTransaction,
    required SerialTransactionChangeMode removeType,
     Timestamp? date,
  }) async {
    return removeSerialTransactionUsingId(
      id: serialTransaction.id,
      removeType: removeType,
      date: date,
    );
  }

  Future<bool> removeSerialTransactionUsingId({
    required String id,
    required SerialTransactionChangeMode removeType,
     Timestamp? date,
  }) async {
    return _repository.balanceDocument.asyncMap((data) async {
      if (data == null) {
        return false;
      }
      if (SerialTransactionManager.removeSerialTransactionFromData(
        id: id,
        data: data,
        removeType: removeType,
        date: date,
      )) {
        await _repository.set(data);
        return true;
      }

      return false;
    }).first;
  }
}
