
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:linum/common/interfaces/time_span.dart';
import 'package:linum/common/utils/date_time_map.dart';
import 'package:linum/core/balance/domain/models/changed_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/domain/utils/date_time_calculation_functions.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/utils/repeated_balance_help_functions.dart';
import 'package:linum/screens/enter_screen/presentation/utils/get_repeat_interval.dart';
import 'package:uuid/uuid.dart';

///  Repeated Balance Data
///  Model for defining information used by a card that is a repeated "copy" of an "original" Transaction to be repeated in a given timeframe
class SerialTransaction extends TimeSpan<SerialTransaction> {
  final num amount;
  final String category;
  final String currency;
  final String id;
  final String name;
  final String? note;
  final DateTimeMap<String, ChangedTransaction>? changed;
  final DateTime startDate;
  final DateTime? endDate;
  final int repeatDuration;
  final RepeatDurationType repeatDurationType;

  RepeatInterval get repeatInterval => getRepeatInterval(
      repeatDuration, repeatDurationType,
  );

  SerialTransaction({
    required this.amount,
    required this.category,
    required this.currency,
    String? id,
    required this.name,
    this.note,
    this.changed,
    required this.startDate,
    this.endDate,
    required this.repeatDuration,
    this.repeatDurationType = RepeatDurationType.seconds,
  })  : id = id ?? TimeSpan.newId();

  bool isIncome() {
    return amount > 0;
  }

  SerialTransaction copyWith({
    num? amount,
    String? category,
    String? currency,
    String? id,
    String? name,
    String? note,
    DateTimeMap<String, ChangedTransaction>? changed,
    String? repeatId,
    DateTime? startDate, // TODO: Map to datetime in adapter
    DateTime? endDate,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
  }) {
    return SerialTransaction(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      changed: changed ?? this.changed,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      repeatDuration: repeatDuration ?? this.repeatDuration,
      repeatDurationType: repeatDurationType ?? this.repeatDurationType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'currency': currency,
      'id': id,
      'name': name,
      'note': note,
      'changed': changed?.map((key, value) => MapEntry(key, value.toMap())), // TODO: Check if this should be removed when building a map
      'initialTime': startDate,
      'endTime': endDate,
      'repeatDuration': repeatDuration,
      'repeatDurationType': repeatDurationType.name,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'category': category,
      'currency': currency,
      'id': id,
      'name': name,
      'note': note,
      'changed': changed?.map((key, value) => MapEntry(key, value.toFirestore())), // TODO: Check if this should be removed when building a map
      'initialTime': firestore.Timestamp.fromDate(startDate),
      'endTime': endDate != null ? firestore.Timestamp.fromDate(endDate!) : null,
      'repeatDuration': repeatDuration,
      'repeatDurationType': repeatDurationType.name,
    };
  }

  factory SerialTransaction.fromMap(Map<String, dynamic> map) {
    final changed = DateTimeMap.fromDynamicMap(
        map['changed'],
        keyMapper: (key) => key as String,
        valueMapper: (value) => ChangedTransaction.fromMap(value as Map<String, dynamic>),
    );

    var category = map['category'] as String?;
    final amount = map['amount'] as num;

    if (category == null) {
      if (amount < 0) {
        category = "none-expense";
      } else {
        category = "none-income";
      }
    }

    return SerialTransaction(
      amount: amount,
      category: category,
      currency: map['currency'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      note: map['note'] as String?,
      changed: changed, // TODO: Might not work
      startDate: map['initialTime'] as DateTime,
      endDate: map['endTime'] as DateTime?,
      repeatDuration: map['repeatDuration'] as int,
      repeatDurationType:  repeatDurationTypeFromString(map['repeatDurationType'] as String) ??
          RepeatDurationType.seconds,
    );
  }

  factory SerialTransaction.fromFirestore(Map<String, dynamic> map) {
    final changed = DateTimeMap.fromDynamicMap(
      map['changed'],
      keyMapper: (key) => key as String,
      valueMapper: (value) => ChangedTransaction.fromFirestore(value as Map<String, dynamic>),
    );

    var category = map['category'] as String?;
    final amount = map['amount'] as num;

    if (category == null) {
      if (amount < 0) {
        category = "none-expense";
      } else {
        category = "none-income";
      }
    }

    return SerialTransaction(
      amount: amount,
      category: category,
      currency: map['currency'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      note: map['note'] as String?,
      changed: changed, // TODO: Might not work
      startDate: (map['initialTime'] as firestore.Timestamp).toDate(),
      endDate: (map['endTime'] as firestore.Timestamp?)?.toDate(),
      repeatDuration: map['repeatDuration'] as int,
      repeatDurationType:  repeatDurationTypeFromString(map['repeatDurationType'] as String) ??
          RepeatDurationType.seconds,
    );
  }

  @override
  String toString() {
    return 'RepeatBalanceData(amount: $amount, category: $category, currency: $currency, id: $id, name: $name, note: $note, changed: $changed, startDate: $startDate, endTime: $endDate, repeatDuration: $repeatDuration, repeatDurationType: $repeatDurationType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SerialTransaction &&
        other.amount == amount &&
        other.category == category &&
        other.currency == currency &&
        other.id == id &&
        other.name == name &&
        other.note == note &&
        other.changed == changed &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.repeatDuration == repeatDuration &&
        other.repeatDurationType == repeatDurationType;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        category.hashCode ^
        currency.hashCode ^
        id.hashCode ^
        name.hashCode ^
        note.hashCode ^
        changed.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        repeatDuration.hashCode ^
        repeatDurationType.hashCode;
  }


  List<Transaction> generateTransactions(DateTime till) {
    final List<Transaction> transactions = [];

    DateTime currentTime = startDate;

    // while we are before 1 years after today / before endDate
    while ((endDate == null ||
        !endDate!.isBefore(currentTime)) &&
        !till.isBefore(currentTime)) {
      // if "changed" -> "this  Timestamp" -> deleted exist AND it is true, dont add this balance
      if (changed == null ||
          changed!.get(currentTime) == null ||
          changed!.get(currentTime)!.deleted == null ||
          !changed!.get(currentTime)!.deleted!) {
        transactions.add(
          Transaction(
            amount: changed?.get(currentTime)?.amount ??
                amount,
            category: changed?.get(currentTime)?.category ??
                category,
            currency: changed?.get(currentTime)?.currency ??
                currency,
            name: changed?.get(currentTime)?.name ??
                name,
            date: changed?.get(currentTime)?.date ?? currentTime,
            repeatId: id,
            id: const Uuid().v4(),
            formerDate: (changed?.get(currentTime)?.date != null)
                ?  currentTime
                : null,
          ),
        );
      }
      currentTime = calculateOneTimeStep(
        repeatDuration,
        currentTime,
        // is it a month or second duration type
        monthly: isMonthly(this),
        dayOfTheMonth: startDate.day,
      );
    }
    return transactions;
  }

  @override
  SerialTransaction copySpanWith({DateTime? start, DateTime? end, String? id}) {
    return copyWith(
      startDate: start,
      endDate: end,
    );
  }

  @override
  DateTime getStart() => startDate;

  @override
  DateTime? getEnd() => endDate;

  @override
  String getId() => id;



}
