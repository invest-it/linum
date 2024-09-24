import 'package:linum/core/balance/domain/balance_data_repository.dart';
import 'package:linum/core/balance/domain/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/domain/use_cases/remove_serial_transaction_use_case.dart';
import 'package:linum/core/balance/domain/use_cases/update_serial_transaction_use_case.dart';
import 'package:linum/core/balance/presentation/balance_data_service.dart';


class BalanceDataServiceImpl extends IBalanceDataService {
  final IBalanceDataRepository _repo;
  late final _updateSerialUseCase = UpdateSerialTransactionUseCase(repository: _repo);
  late final _removeSerialUseCase = RemoveSerialTransactionUseCase(repository: _repo);

  BalanceDataServiceImpl({
    required IBalanceDataRepository repo,
  }) : _repo = repo;

  @override
  Future<List<SerialTransaction>> getSerialTransactionsForMonth(DateTime month) async {
    return await _repo.getSerialTransactionsForMonth(month);
  }

  @override
  Future<List<Transaction>> getTransactionsForMonth(DateTime month) async {
    return await _repo.getTransactionsForMonth(month);
  }

  @override
  Future<SerialTransaction?> getSerialTransactionById(String id) async {
    return await _repo.getSerialTransactionById(id);
  }

  @override
  Future<void> addSerialTransaction(SerialTransaction serialTransaction) async {
    // conditions
    if (serialTransaction.category == "") {
      throw ArgumentError("repeatBalanceData.category must be != '' ",);
    }
    if (serialTransaction.currency == "") {
      throw ArgumentError("repeatBalanceData.currency must be != '' ",);
    }

    await _repo.createSerialTransaction(serialTransaction);
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }

  
  @override
  Future<void> addTransaction(Transaction transaction) async {
    // conditions
    if (transaction.category == "") {
      throw ArgumentError("transaction.category must be != '' ");
    }
    if (transaction.currency == "") {
      throw ArgumentError("transaction.currency must be != '' ");
    }

    await _repo.createTransaction(transaction);
    notifyListeners();
  }
  
  @override
  Future<void> removeTransactionWithId(String id) async {
    final transaction = await _repo.getTransactionById(id);
    if (transaction == null) {
      return;
    }
    await _repo.removeTransaction(transaction);
    notifyListeners();
  }

  @override
  Future<void> removeTransaction(Transaction transaction) async {
    await _repo.removeTransaction(transaction);
    notifyListeners();
  }

  @override
  Future<void> updateTransaction(Transaction update) async {
    // conditions
    if (update.id == "") {
      throw ArgumentError("no id provided");
    }
    if (update.category == "") {
      throw ArgumentError("category must be != '' ");
    }
    if (update.currency == "") {
      throw ArgumentError("currency must be != '' ");
    }
    await _repo.updateTransaction(update);
    notifyListeners();
  }

  @override
  Future<bool> ready() async {
    final isReady = await _repo.ready();
    notifyListeners();
    return isReady;
  }

  @override
  Future<List<SerialTransaction>> getAllSerialTransactions() async
    => _repo.getAllSerialTransactions();


  @override
  Future<List<Transaction>> getAllTransactions() async
    => _repo.getAllTransactions();
}
