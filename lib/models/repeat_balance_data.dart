import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:linum/models/repeat_duration_type_enum.dart';
import 'package:uuid/uuid.dart';

class RepeatBalanceData {
  final num _amount;
  final String _category;
  final String _currency;
  final String _id;
  final String _name;

  final Timestamp _initialTime;
  final Timestamp? _endTime;
  final int _repeatDuration;
  final RepeatDurationType _repeatDurationType;

  RepeatBalanceData({
    required num amount,
    required String category,
    required String currency,
    String? id,
    required String name,
    required Timestamp initialTime,
    Timestamp? endTime,
    required int repeatDuration,
    RepeatDurationType repeatDurationType = RepeatDurationType.seconds,
  })  : _amount = amount,
        _category = category,
        _currency = currency,
        _id = id ?? const Uuid().v4(),
        _name = name,
        _initialTime = initialTime,
        _endTime = endTime,
        _repeatDuration = repeatDuration,
        _repeatDurationType = repeatDurationType;

  RepeatBalanceData copyWith({
    num? amount,
    String? category,
    String? currency,
    String? id,
    String? name,
    String? repeatId,
    Timestamp? initialTime,
    Timestamp? endTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
  }) {
    return RepeatBalanceData(
      amount: amount ?? _amount,
      category: category ?? _category,
      currency: currency ?? _currency,
      id: id ?? _id,
      name: name ?? _name,
      initialTime: initialTime ?? _initialTime,
      endTime: endTime ?? _endTime,
      repeatDuration: repeatDuration ?? _repeatDuration,
      repeatDurationType: repeatDurationType ?? _repeatDurationType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_amount': _amount,
      '_category': _category,
      '_currency': _currency,
      '_id': _id,
      '_name': _name,
      '_initialTime': _initialTime,
      '_endTime': _endTime,
      '_repeatDuration': _repeatDuration,
      '_repeatDurationType': _repeatDurationType,
    };
  }

  factory RepeatBalanceData.fromMap(Map<String, dynamic> map) {
    return RepeatBalanceData(
      amount: map['amount'] as num,
      category: map['category'] as String,
      currency: map['currency'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      initialTime: map['initialTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp?,
      repeatDuration: map['repeatDuration'] as int,
      repeatDurationType: map['repeatDurationType'] as RepeatDurationType? ??
          RepeatDurationType.seconds,
    );
  }

  @override
  String toString() {
    return 'RepeatBalanceData(_amount: $_amount, _category: $_category, _currency: $_currency, _id: $_id, _name: $_name, _initialTime: $_initialTime, _endTime: $_endTime, _repeatDuration: $_repeatDuration, _repeatDurationType: $_repeatDurationType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RepeatBalanceData &&
        other._amount == _amount &&
        other._category == _category &&
        other._currency == _currency &&
        other._id == _id &&
        other._name == _name &&
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
        _initialTime.hashCode ^
        _endTime.hashCode ^
        _repeatDuration.hashCode ^
        _repeatDurationType.hashCode;
  }

  num get amount => _amount;
  String get category => _category;
  String get currency => _currency;
  String get id => _id;
  String get name => _name;
  Timestamp get initialTime => _initialTime;
  Timestamp? get endTime => _endTime;
  int get repeatDuration => _repeatDuration;
  RepeatDurationType get repeatDurationType => _repeatDurationType;
}
