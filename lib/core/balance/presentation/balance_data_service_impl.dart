import 'package:linum/core/balance/domain/balance_data_repository.dart';
import 'package:linum/core/balance/domain/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/domain/use_cases/remove_serial_transaction_use_case.dart';
import 'package:linum/core/balance/domain/use_cases/update_serial_transaction_use_case.dart';
import 'package:linum/core/balance/presentation/balance_data_service.dart';

class WrongParameterException implements Exception {
  final String message;

  WrongParameterException(this.message);
}

class BalanceDataServiceImpl extends IBalanceDataService {
  final IBalanceDataRepository _repo;
  late final _updateSerialUseCase = UpdateSerialTransactionUseCase(repository: _repo);
  late final _removeSerialUseCase = RemoveSerialTransactionUseCase(repository: _repo);

  BalanceDataServiceImpl({
    required IBalanceDataRepository repo,
  }) : _repo = repo;

  @override
  Future<List<SerialTransaction>> getSerialTransactionsForMonth(DateTime month) {
    return _repo.getSerialTransactionsForMonth(month);
  }

  @override
  Future<List<Transaction>> getTransactionsForMonth(DateTime month) {
    return _repo.getTransactionsForMonth(month);
  }

  @override
  Future<SerialTransaction?> getSerialTransactionById(String id) {
    return _repo.getSerialTransactionById(id);
  }

  @override
  Future<void> addSerialTransaction(SerialTransaction serialTransaction) async {
    // conditions
    if (serialTransaction.category == "") {
      throw WrongParameterException(
          "repeatBalanceData.category must be != '' ",);
    }
    if (serialTransaction.currency == "") {
      throw WrongParameterException(
          "repeatBalanceData.currency must be != '' ",);
    }

    await _repo.createSerialTransaction(serialTransaction);
  }

  @override
  Future<void> removeSerialTransactionWithId({
    required String id,
    required SerialTransactionChangeMode removeType,
    DateTime? date,
  }) async {
    await _removeSerialUseCase.removeSerialTransaction(
        id: id,
        removeType: removeType,
        date: date,
    );
  }

  @override
  Future<void> removeSerialTransaction({
    required SerialTransaction serialTransaction,
    required SerialTransactionChangeMode removeType,
    DateTime? date,
  }) async {
    await _removeSerialUseCase.removeSerialTransaction(
      id: serialTransaction.id,
      removeType: removeType,
      date: date,
    );
  }

  @override
  Future<void> updateSerialTransaction({
    required SerialTransaction update,
    required SerialTransactionChangeMode changeMode,
    DateTime? oldDate,
    DateTime? newDate,
    bool resetEndDate = false,
  }) async {
    await _updateSerialUseCase.updateSerialTransaction(
      id: update.id,
      amount: update.amount,
      category: update.category,
      currency: update.currency,
      name: update.name,
      note: update.note,
      startDate: update.startDate,
      repeatDuration: update.repeatDuration,
      repeatDurationType: update.repeatDurationType,
      endDate: update.endDate,
      changeType: changeMode,
      resetEndDate: resetEndDate,
      oldDate: oldDate,
      newDate: newDate,
    );
  }

  
  @override
  Future<void> addTransaction(Transaction transaction) async {
    // conditions
    if (transaction.category == "") {
      throw WrongParameterException("transaction.category must be != '' ");
    }
    if (transaction.currency == "") {
      throw WrongParameterException("transaction.currency must be != '' ");
    }

    await _repo.createTransaction(transaction);
  }
  
  @override
  Future<void> removeTransactionWithId(String id) async {
    final transaction = await _repo.getTransactionById(id);
    if (transaction == null) {
      return;
    }
    await _repo.removeTransaction(transaction);
  }

  @override
  Future<void> removeTransaction(Transaction transaction) async {
    await _repo.removeTransaction(transaction);
  }

  @override
  Future<void> updateTransaction(Transaction update) async {
    // conditions
    if (update.id == "") {
      throw WrongParameterException("no id provided");
    }
    if (update.category == "") {
      throw WrongParameterException("category must be != '' ");
    }
    if (update.currency == "") {
      throw WrongParameterException("currency must be != '' ");
    }
    await _repo.updateTransaction(update);
  }

  @override
  Future<bool> ready() => _repo.ready();

  @override
  Future<List<SerialTransaction>> getAllSerialTransactions()
    => _repo.getAllSerialTransactions();


  @override
  Future<List<Transaction>> getAllTransactions()
    => _repo.getAllTransactions();
}
