//  Repeated Balance Data - Model for defining information used by a card that is a repeated "copy" of an "original" Transaction to be repeated in a given timeframe
//
//  Author: SoTBurst
//  Co-Author: n/a //TODO @SoTBurst teach someone else how to maintain this, might be important in the future
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/models/changed_repeated_balance.dart';
import 'package:linum/types/date_time_map.dart';
import 'package:uuid/uuid.dart';

class RepeatedBalanceData {
  num amount;
  String category;
  String currency;
  String id;
  String name;
  String? note;
  DateTimeMap<String, ChangedRepeatedBalanceData>? changed;
  Timestamp initialTime;
  Timestamp? endTime;
  int repeatDuration;
  RepeatDurationType repeatDurationType;

  RepeatedBalanceData({
    required this.amount,
    required this.category,
    required this.currency,
    String? id,
    required this.name,
    this.note,
    this.changed,
    required this.initialTime,
    this.endTime,
    required this.repeatDuration,
    this.repeatDurationType = RepeatDurationType.seconds,
  })  : id = id ?? const Uuid().v4();

  RepeatedBalanceData copyWith({
    num? amount,
    String? category,
    String? currency,
    String? id,
    String? name,
    String? note,
    DateTimeMap<String, ChangedRepeatedBalanceData>? changed,
    String? repeatId,
    Timestamp? initialTime,
    Timestamp? endTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
  }) {
    return RepeatedBalanceData(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      changed: changed ?? this.changed,
      initialTime: initialTime ?? this.initialTime,
      endTime: endTime ?? this.endTime,
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
      'initialTime': initialTime,
      'endTime': endTime,
      'repeatDuration': repeatDuration,
      'repeatDurationType': repeatDurationType.name,
    };
  }

  factory RepeatedBalanceData.fromMap(Map<String, dynamic> map) {
    return RepeatedBalanceData(
      amount: map['amount'] as num,
      category: map['category'] as String,
      currency: map['currency'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      note: map['note'] as String?,
      changed: map['changed'] as DateTimeMap<String, ChangedRepeatedBalanceData>?, // TODO: Might not work
      initialTime: map['initialTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp?,
      repeatDuration: map['repeatDuration'] as int,
      repeatDurationType:  repeatDurationTypeFromString(map['repeatDurationType'] as String) ??
          RepeatDurationType.seconds,
    );
  }

  @override
  String toString() {
    return 'RepeatBalanceData(amount: $amount, category: $category, currency: $currency, id: $id, name: $name, note: $note, changed: $changed, initialTime: $initialTime, endTime: $endTime, repeatDuration: $repeatDuration, repeatDurationType: $repeatDurationType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RepeatedBalanceData &&
        other.amount == amount &&
        other.category == category &&
        other.currency == currency &&
        other.id == id &&
        other.name == name &&
        other.note == note &&
        other.changed == changed &&
        other.initialTime == initialTime &&
        other.endTime == endTime &&
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
        initialTime.hashCode ^
        endTime.hashCode ^
        repeatDuration.hashCode ^
        repeatDurationType.hashCode;
  }


}




