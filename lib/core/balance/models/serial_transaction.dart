//  Repeated Balance Data - Model for defining information used by a card that is a repeated "copy" of an "original" Transaction to be repeated in a given timeframe
//
//  Author: SoTBurst
//  Co-Author: n/a //TODO @SoTBurst teach someone else how to maintain this, might be important in the future
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/common/utils/date_time_map.dart';
import 'package:linum/core/balance/models/changed_transaction.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:uuid/uuid.dart';

class SerialTransaction {
  final num amount;
  final String? category;
  final String currency;
  final String id;
  final String name;
  final String? note;
  final DateTimeMap<String, ChangedTransaction>? changed;
  final Timestamp startDate;
  final Timestamp? endDate;
  final int repeatDuration;
  final RepeatDurationType repeatDurationType;

  SerialTransaction({
    required this.amount,
    this.category,
    required this.currency,
    String? id,
    required this.name,
    this.note,
    this.changed,
    required this.startDate,
    this.endDate,
    required this.repeatDuration,
    this.repeatDurationType = RepeatDurationType.seconds,
  })  : id = id ?? const Uuid().v4();

  SerialTransaction copyWith({
    num? amount,
    String? category,
    String? currency,
    String? id,
    String? name,
    String? note,
    DateTimeMap<String, ChangedTransaction>? changed,
    String? repeatId,
    Timestamp? startDate,
    Timestamp? endDate,
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

  factory SerialTransaction.fromMap(Map<String, dynamic> map) {
    final changed = DateTimeMap.fromDynamicMap(
        map['changed'],
        keyMapper: (key) => key as String,
        valueMapper: (value) => ChangedTransaction.fromMap(value as Map<String, dynamic>),
    );

    return SerialTransaction(
      amount: map['amount'] as num,
      category: map['category'] as String?,
      currency: map['currency'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      note: map['note'] as String?,
      changed: changed, // TODO: Might not work
      startDate: map['initialTime'] as Timestamp,
      endDate: map['endTime'] as Timestamp?,
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


}
