import 'package:linum/common/interfaces/time_span.dart';
import 'package:linum/common/utils/date_time_map.dart';
import 'package:linum/core/balance/domain/balance_data_repository.dart';
import 'package:linum/core/balance/domain/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/domain/models/changed_transaction.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/utils/date_time_calculation_functions.dart';
import 'package:linum/core/budget/domain/models/changes.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:linum/core/repeating/utils/repeated_balance_help_functions.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class UpdateSerialTransactionUseCase {
  final IBalanceDataRepository _repository;
  final logger = Logger();

  UpdateSerialTransactionUseCase({required IBalanceDataRepository repository}) : _repository = repository;
  
  Future<bool> updateAll({
    required String id,
    num? amount,
    String? category,
    String? currency,
    DateTime? endDate,
    DateTime? startDate,
    String? name,
    String? note,
    DateTime? newDate,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool resetEndDate = false,
    DateTime? oldDate,
  }) async {
    bool isEdited = false;

    final serialTransaction = await _repository.getSerialTransactionById(id);
    if (serialTransaction == null) {
      return false;
    }

    num? updatedAmount;
    String? updatedCategory;
    String? updatedCurrency;
    String? updatedName;
    String? updatedNote;
    DateTimeMap<String, ChangedTransaction>? updatedChanged =
        serialTransaction.changed;
    DateTime? updatedInitialTime;
    DateTime? updatedEndTime;
    int? updatedRepeatDuration;
    RepeatDurationType? updatedRepeatDurationType;

    if (amount != null && amount != serialTransaction.amount) {
      updatedAmount = amount;
      isEdited = true;
    }
    if (category != null && category != serialTransaction.category) {
      updatedCategory = category;
      isEdited = true;
    }
    if (currency != null && currency != serialTransaction.currency) {
      updatedCurrency = currency;
      isEdited = true;
    }
    if (name != null && name != serialTransaction.name) {
      updatedName = name;
      isEdited = true;
    }
    if (note != null && note != serialTransaction.note) {
      updatedNote = note;
      isEdited = true;
    }
    if (startDate != null && startDate != serialTransaction.startDate) {
      updatedInitialTime = startDate;
      isEdited = true;
    } else if (newDate != null && oldDate != null) {
      updatedInitialTime =  serialTransaction.getStart().subtract(
        oldDate.difference(newDate),
      );
      if (serialTransaction.getEnd() != null) {
        updatedEndTime =  serialTransaction.getEnd()!.subtract(
          oldDate.difference(newDate),
        );
      }
      isEdited = true;
    }
    if (repeatDuration != null &&
        repeatDuration != serialTransaction.repeatDuration) {
      updatedRepeatDuration = repeatDuration;
      isEdited = true;
    }
    if (repeatDurationType != null &&
        repeatDurationType != serialTransaction.repeatDurationType) {
      updatedRepeatDurationType = repeatDurationType;
      isEdited = true;
    }
    if (endDate != null && endDate != serialTransaction.endDate) {
      updatedEndTime = endDate;
      isEdited = true;
    }
    if (resetEndDate) {
      updatedEndTime = null;
      isEdited = true;
    }
    if (startDate != null ||
        repeatDuration != null ||
        repeatDurationType != null ||
        (newDate != null && oldDate != null)) {
      // FUTURE lazy approach. might think of something clever in the future
      // (what if repeat duration changes. single repeatable changes change time or not? use the nth? complicated...)
      updatedChanged = null;
    }

    if (isEdited && serialTransaction.changed != null) {
      serialTransaction.changed?.forEach((key, value) {
        if (amount != null) {
          value.amount = null;
        }
        if (category != null) {
          value.category = null;
        }
        if (currency != null) {
          value.currency = null;
        }
        if (name != null) {
          value.name = null;
        }
        if (note != null) {
          value.note = null;
        }
        if (newDate != null) {
          value.date = null;
        }
        // TODO: Ganz großes Fragezeichen
        // dont need startDate
        // dont need repeatDuration
        // dont need repeatDurationType
        // dont need endDate
        // dont need resetEndTime,
      });
    }

    final updatedSerialTransaction = SerialTransaction(
      id: serialTransaction.id,
      amount: updatedAmount ?? serialTransaction.amount,
      category: updatedCategory ?? serialTransaction.category,
      currency: updatedCurrency ?? serialTransaction.currency,
      startDate: updatedInitialTime ?? serialTransaction.startDate,
      endDate:
      resetEndDate ? null : (updatedEndTime ?? serialTransaction.endDate),
      name: updatedName ?? serialTransaction.name,
      note: updatedNote ?? serialTransaction.note,
      changed: updatedChanged,
      repeatDuration: updatedRepeatDuration ?? serialTransaction.repeatDuration,
      repeatDurationType:
      updatedRepeatDurationType ?? serialTransaction.repeatDurationType,
    );

    await _repository.updateSerialTransaction(updatedSerialTransaction);

    return isEdited;
  }

  Future<bool> updateThisAndAllBefore({
    required String id,
    required  DateTime oldDate,
    num? amount,
    String? category,
    String? currency,
    DateTime? endDate,
    DateTime? startDate,
    String? name,
    String? note,
    DateTime? newDate,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndDate,
  }) async {
    bool isEdited = false;

    final oldSerialTransaction = await _repository.getSerialTransactionById(id);
    if (oldSerialTransaction == null) {
      return false;
    }

    DateTime? updatedInitialTime;

    if (oldSerialTransaction.repeatDurationType.name.toUpperCase() ==
        "MONTHS") {
      updatedInitialTime = calculateOneTimeStep(
        oldSerialTransaction.repeatDuration,
        oldDate,
        monthly: true,
        dayOfTheMonth: oldDate.day,
      );
    } else {
      updatedInitialTime = calculateOneTimeStep(
        oldSerialTransaction.repeatDuration,
        oldDate,
        monthly: false,
      );
    }
    final Duration timeDifference = oldDate.difference(newDate ?? oldDate);

    final newSerialTransaction = oldSerialTransaction.copyWith(
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      startDate: startDate ?? oldSerialTransaction.startDate.subtract(timeDifference),
      id: const Uuid().v4(),
      repeatDuration: repeatDuration,
      repeatDurationType: repeatDurationType,
      endDate: oldDate.subtract(timeDifference),
      note: note,
    );

    removeUnusedChangedAttributes(newSerialTransaction);
    removeUnusedChangedAttributes(oldSerialTransaction);

    isEdited = true;

    await _repository.executeSerialTransactionChanges([
      ModelChange(ChangeType.update, oldSerialTransaction.copyWith(
        startDate: updatedInitialTime,
      ),),
      ModelChange(ChangeType.create, newSerialTransaction),
    ]);

    return isEdited;
  }

  Future<bool> updateThisAndAllAfter({
    required String id,
    required  DateTime oldDate,
    num? amount,
    String? category,
    String? currency,
    DateTime? endDate,
    DateTime? startDate,
    String? name,
    DateTime? newDate,
    String? note,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    bool? resetEndDate,
  }) async {
    bool isEdited = false;

    final oldSerialTransaction = await _repository.getSerialTransactionById(id);
    if (oldSerialTransaction == null) {
      return false;
    }

    DateTime? updatedEndTime;

    if (oldSerialTransaction.repeatDurationType.name.toUpperCase() == "MONTHS") {
      updatedEndTime = calculateOneTimeStepBackwards(
        oldSerialTransaction.repeatDuration,
        oldDate,
        monthly: true,
        dayOfTheMonth: oldDate.day,
      );
    } else {
      updatedEndTime = calculateOneTimeStepBackwards(
        oldSerialTransaction.repeatDuration,
        oldDate,
        monthly: false,
        dayOfTheMonth: oldDate.day,
      );
    }
    final Duration timeDifference =
    oldDate.difference(newDate ?? oldDate);

    final newSerialTransaction = oldSerialTransaction.copyWith(
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      startDate: oldDate.subtract(timeDifference),
      id: TimeSpan.newId(),
      repeatDuration: repeatDuration,
      repeatDurationType: repeatDurationType,
      endDate: changeThisAndAllAfterEndTimeHelpFunction(
        endDate,
        oldSerialTransaction,
        timeDifference,
      ),
    );

    removeUnusedChangedAttributes(newSerialTransaction);
    removeUnusedChangedAttributes(oldSerialTransaction);

    isEdited = true;

    await _repository.executeSerialTransactionChanges([
      ModelChange(ChangeType.update, oldSerialTransaction.copyWith(endDate: updatedEndTime)),
      ModelChange(ChangeType.create, newSerialTransaction),
    ]);

    return isEdited;
  }

  // TODO: Delete note
  Future<bool> updateOnlyThisOne({
    required String id,
    required  DateTime date,
    required ChangedTransaction changed,
  }) async {
    final serialTransaction = await _repository.getSerialTransactionById(id);
    if (serialTransaction == null) {
      return false;
    }
    final changedMap = serialTransaction.changed ?? DateTimeMap();

    changedMap.addAll({date.millisecondsSinceEpoch.toString(): changed});

    await _repository.updateSerialTransaction(serialTransaction.copyWith(changed: changedMap));

    return true;
  }


  // TODO: Start using exceptions
  Future<bool> updateSerialTransaction({
    required SerialTransactionChangeMode changeType,
    required String id,
    num? amount,
    String? category,
    String? currency,
    String? name,
    String? note,
    DateTime ? startDate,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    DateTime ? endDate,
    bool resetEndDate = false,
    DateTime ? oldDate,
    DateTime ? newDate,
  }) async {
    // conditions
    if (id == "") {
      logger.e("no id provided");
      return false;
    }
    if (changeType.isThisAndAllBefore()) {
      if (oldDate == null) {
        logger.e("RepeatableChangeType.thisAndAllBefore => date != null");
        return false;
      }
      if (resetEndDate) {
        logger.e(
          "resetEndTime, endDate are no available for RepeatableChangeType.thisAndAllBefore",
        );
        return false;
      }
    }
    if (changeType.isThisAndAllAfter()) {
      if (oldDate == null) {
        logger.e("RepeatableChangeType.thisAndAllAfter => date != null");
        return false;
      }
      if (startDate != null) {
        logger.e(
          "startDate is no available for RepeatableChangeType.thisAndAllAfter",
        );
        return false;
      }
    }
    if (changeType.isOnlyThisOne()) {
      if (oldDate == null) {
        logger.e("RepeatableChangeType.onlyThisOne => date != null");
        return false;
      }
    }
    if (currency == "") {
      logger.e("currency must be != '' ");
      return false;
    }

    // check if changes happen

    num? checkedAmount;
    String? checkedCategory;
    String? checkedCurrency;
    String? checkedName;
    String? checkedNote;
    DateTime ? checkedInitialTime;
    int? checkedRepeatDuration;
    RepeatDurationType? checkedRepeatDurationType;
    DateTime ? checkedEndTime;
    DateTime ? checkedNewDate;

    final serialTransaction = await _repository.getSerialTransactionById(id);

    if (serialTransaction != null) {
      if (amount != serialTransaction.amount) {
        checkedAmount = amount;
      }
      if (category != serialTransaction.category) {
        checkedCategory = category;
      }
      if (currency != serialTransaction.currency) {
        checkedCurrency = currency;
      }
      if (name != serialTransaction.name) {
        checkedName = name;
      }
      if (note != serialTransaction.note) {
        checkedNote = note;
      }
      if (startDate != serialTransaction.startDate) {
        checkedInitialTime = startDate;
      }
      if (repeatDuration != serialTransaction.repeatDuration) {
        checkedRepeatDuration = repeatDuration;
      }
      if (repeatDurationType != serialTransaction.repeatDurationType) {
        checkedRepeatDurationType = repeatDurationType;
      }
      if (endDate != serialTransaction.endDate) {
        checkedEndTime = endDate;
      }
      if (newDate != oldDate) {
        checkedNewDate = newDate;
      }
    }


    switch (changeType) {
      case SerialTransactionChangeMode.all:
        return updateAll(
          amount: checkedAmount,
          category: checkedCategory, // TODO Null value might be a problem
          currency: checkedCurrency,
          endDate: checkedEndTime,
          id: id,
          startDate: checkedInitialTime,
          name: checkedName,
          note: checkedNote,
          newDate: checkedNewDate,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndDate: resetEndDate,
          oldDate: oldDate,
        );
      case SerialTransactionChangeMode.thisAndAllBefore:
        return updateThisAndAllBefore(
          amount: checkedAmount,
          category: checkedCategory, // TODO Null value might be a problem
          currency: checkedCurrency,
          endDate: checkedEndTime,
          id: id,
          startDate: checkedInitialTime,
          name: checkedName,
          note: checkedNote,
          newDate: checkedNewDate,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndDate: resetEndDate,
          oldDate: oldDate!,
        );
      case SerialTransactionChangeMode.thisAndAllAfter:
        return updateThisAndAllAfter(
          amount: checkedAmount,
          category: checkedCategory, // TODO Null value might be a problem
          currency: checkedCurrency,
          endDate: checkedEndTime,
          id: id,
          startDate: checkedInitialTime,
          name: checkedName,
          newDate: checkedNewDate,
          repeatDuration: checkedRepeatDuration,
          repeatDurationType: checkedRepeatDurationType,
          resetEndDate: resetEndDate,
          oldDate: oldDate!,
        );

      case SerialTransactionChangeMode.onlyThisOne:
        return updateOnlyThisOne(
          id: id,
          date: oldDate!,
          changed: ChangedTransaction(
            amount: checkedAmount,
            category: checkedCategory, // TODO Null value might be a problem
            currency: checkedCurrency,
            name: checkedName,
            note: checkedNote,
            date: checkedNewDate,
          ),
        );
    }
  }
}
