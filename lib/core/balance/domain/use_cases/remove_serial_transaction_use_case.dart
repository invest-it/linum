import 'package:linum/common/utils/date_time_map.dart';
import 'package:linum/core/balance/domain/balance_data_repository.dart';
import 'package:linum/core/balance/domain/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/domain/models/changed_transaction.dart';
import 'package:logger/logger.dart';

class RemoveSerialTransactionUseCase {
  final IBalanceDataRepository _repository;
  final Logger logger = Logger();

  RemoveSerialTransactionUseCase({required IBalanceDataRepository repository}) : _repository = repository;

  Future<bool> removeAll(String id) async {
    final serialTransaction = await _repository.getSerialTransactionById(id);
    if (serialTransaction == null) {
      logger.e("The repeatable balance wasn't found"); // ???
      return false;
    }

    await _repository.removeSerialTransaction(serialTransaction);
    return true;
  }

  Future<bool> removeThisAndAllBefore(
      String id,
      DateTime date,
      ) async {
    final serialTransaction = await _repository.getSerialTransactionById(id);

    if (serialTransaction == null) {
      return false;
    }

    // if not month => seconds
    var newInitialDate = date.add(
      Duration(
        seconds: serialTransaction.repeatDuration,
      ),
    );

    if (serialTransaction.repeatDurationType.name.toUpperCase() == "MONTHS") {
      newInitialDate = DateTime(
        date.year,
        date.month + serialTransaction.repeatDuration,
        date.day,
      );
    }

    await _repository.updateSerialTransaction(serialTransaction.copyWith(startDate: newInitialDate));

    return true;
  }

  Future<bool> removeThisAndAllAfter(
      String id,
      DateTime date,
      ) async {
    final serialTransaction = await _repository.getSerialTransactionById(id);

    if (serialTransaction == null) {
      return false;
    }

    // if not month => seconds
    var newEndTime = date.subtract(
      Duration(
        seconds: serialTransaction.repeatDuration,
      ),
    );

    if (serialTransaction.repeatDurationType.name.toUpperCase() == "MONTHS") {
      newEndTime = DateTime(
        date.year,
        date.month - serialTransaction.repeatDuration,
        date.day,
      );
    }
    await _repository.updateSerialTransaction(serialTransaction.copyWith(endDate: newEndTime));
    return true;
  }

  Future<bool> removeOnlyThisOne(
      String id,
      DateTime date,
      ) async {
    final serialTransaction = await _repository.getSerialTransactionById(id);

    if (serialTransaction == null) {
      return false;
    }

    final changed = serialTransaction.changed ?? DateTimeMap();

    changed.addAll({
      date.millisecondsSinceEpoch.toString(): ChangedTransaction(deleted: true),
    });

    await _repository.updateSerialTransaction(serialTransaction.copyWith(changed: changed));
    return true;
  }


  Future<bool> removeSerialTransaction({
    required String id,
    required SerialTransactionChangeMode removeType,
    DateTime? date,
  }) async {
    // conditions
    if (removeType.isThisAndAllBefore() &&
        date == null) {
      logger.e(
        "removeType == RepeatableChangeType.thisAndAllBefore => date != null",
      );
      return false;
    }
    if (removeType.isThisAndAllAfter() &&
        date == null) {
      logger.e(
        "removeType == RepeatableChangeType.thisAndAllAfter => date != null",
      );
      return false;
    }
    if (removeType.isOnlyThisOne() && date == null) {
      logger
          .e("removeType == RepeatableChangeType.onlyThisOne => date != null");
      return false;
    }

    switch (removeType) {
      case SerialTransactionChangeMode.all:
        return removeAll(id);
      case SerialTransactionChangeMode.thisAndAllBefore:
        return removeThisAndAllBefore(
          id, date!,
        );
      case SerialTransactionChangeMode.thisAndAllAfter:
        return removeThisAndAllAfter(
          id, date!,
        );
      case SerialTransactionChangeMode.onlyThisOne:
        return removeOnlyThisOne(id, date!);
    }
  }
}
