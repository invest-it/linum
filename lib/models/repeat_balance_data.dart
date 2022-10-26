//  Repeated Balance Data - Model for defining information used by a card that is a repeated "copy" of an "original" Transaction to be repeated in a given timeframe
//
//  Author: SoTBurst
//  Co-Author: n/a //TODO @SoTBurst teach someone else how to maintain this, might be important in the future
//

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/models/abstract/balance_data.dart';
import 'package:uuid/uuid.dart';

class RepeatedBalanceData implements BalanceData {
  final num _amount;
  final String _category;
  final String _currency;
  final String _id;
  final String _name;
  final String? _note;

  final Timestamp _initialTime;
  final Timestamp? _endTime;
  final int _repeatDuration;
  final RepeatDurationType _repeatDurationType;

  RepeatedBalanceData({
    required num amount,
    required String category,
    required String currency,
    String? id,
    required String name,
    String? note,
    required Timestamp initialTime,
    Timestamp? endTime,
    required int repeatDuration,
    RepeatDurationType repeatDurationType = RepeatDurationType.seconds,
  })  : _amount = amount,
        _category = category,
        _currency = currency,
        _id = id ?? const Uuid().v4(),
        _name = name,
        _note = note,
        _initialTime = initialTime,
        _endTime = endTime,
        _repeatDuration = repeatDuration,
        _repeatDurationType = repeatDurationType;

  RepeatedBalanceData copyWith({
    num? amount,
    String? category,
    String? currency,
    String? id,
    String? name,
    String? note,
    String? repeatId,
    Timestamp? initialTime,
    Timestamp? endTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
  }) {
    return RepeatedBalanceData(
      amount: amount ?? _amount,
      category: category ?? _category,
      currency: currency ?? _currency,
      id: id ?? _id,
      name: name ?? _name,
      note: note ?? _note,
      initialTime: initialTime ?? _initialTime,
      endTime: endTime ?? _endTime,
      repeatDuration: repeatDuration ?? _repeatDuration,
      repeatDurationType: repeatDurationType ?? _repeatDurationType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': _amount,
      'category': _category,
      'currency': _currency,
      'id': _id,
      'name': _name,
      'note': _note,
      'initialTime': _initialTime,
      'endTime': _endTime,
      'repeatDuration': _repeatDuration,
      'repeatDurationType': _repeatDurationType,
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
      initialTime: map['initialTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp?,
      repeatDuration: map['repeatDuration'] as int,
      repeatDurationType:
          repeatDurationTypeFromString(map['repeatDurationType'] as String?) ??
              RepeatDurationType.seconds,
    );
  }

  @override
  String toString() {
    return 'RepeatBalanceData(_amount: $_amount, _category: $_category, _currency: $_currency, _id: $_id, _name: $_name, _note: $_note, _initialTime: $_initialTime, _endTime: $_endTime, _repeatDuration: $_repeatDuration, _repeatDurationType: $_repeatDurationType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RepeatedBalanceData &&
        other._amount == _amount &&
        other._category == _category &&
        other._currency == _currency &&
        other._id == _id &&
        other._name == _name &&
        other._note == _note &&
        other._initialTime == _initialTime &&
        other._endTime == _endTime &&
        other._repeatDuration == _repeatDuration &&
        other._repeatDurationType == _repeatDurationType;
  }

  @override
  int get hashCode {
    return _amount.hashCode ^
        _category.hashCode ^
        _currency.hashCode ^
        _id.hashCode ^
        _name.hashCode ^
        _note.hashCode ^
        _initialTime.hashCode ^
        _endTime.hashCode ^
        _repeatDuration.hashCode ^
        _repeatDurationType.hashCode;
  }

  static RepeatDurationType? repeatDurationTypeFromString(String? str) {
    // WIP TODO NOT IMPLEMENTED
    return null;
  }

  num get amount => _amount;
  String get category => _category;
  String get currency => _currency;
  String get id => _id;
  String get name => _name;
  String? get note => _note;
  Timestamp get initialTime => _initialTime;
  Timestamp? get endTime => _endTime;
  int get repeatDuration => _repeatDuration;
  RepeatDurationType get repeatDurationType => _repeatDurationType;
}
