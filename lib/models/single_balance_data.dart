//  Single Balance Data - Model for defining information used by a card that is NOT a copy of an original repeated transaction ("Single Transacton").
//
//  Author: SoTBurst
//  Co-Author: n/a //TODO @SoTBurst might be useful to train more people on this
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SingleBalanceData {
  final num _amount;
  final String _category;
  final String _currency;
  final String _id;
  final String _name;
  final String? _note;
  final String? _repeatId;
  final Timestamp _time;
  final Timestamp? _formerTime; // strictly for changed repeatables

  SingleBalanceData({
    required num amount,
    required String category,
    required String currency,
    String? id,
    required String name,
    String? note,
    String? repeatId,
    required Timestamp time,
    Timestamp? formerTime,
  })  : _amount = amount,
        _category = category,
        _currency = currency,
        _id = id ?? const Uuid().v4(),
        _name = name,
        _note = note,
        _repeatId = repeatId,
        _time = time,
        _formerTime = formerTime;

  SingleBalanceData copyWith({
    num? amount,
    String? category,
    String? currency,
    String? id,
    String? name,
    String? note,
    String? repeatId,
    Timestamp? time,
    Timestamp? formerTime,
  }) {
    return SingleBalanceData(
      amount: amount ?? _amount,
      category: category ?? _category,
      currency: currency ?? _currency,
      id: id ?? _id,
      name: name ?? _name,
      note: note ?? _note,
      repeatId: repeatId ?? _repeatId,
      time: time ?? _time,
      formerTime: formerTime ?? _formerTime,
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
      'repeatId': _repeatId,
      'time': _time,
      'formerTime': _formerTime,
    };
  }

  factory SingleBalanceData.fromMap(Map<String, dynamic> map) {
    return SingleBalanceData(
      amount: map['amount'] as num,
      category: map['category'] as String,
      currency: map['currency'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      note: map['note'] as String?,
      repeatId: map['repeatId'] as String?,
      time: map['time'] as Timestamp,
      formerTime: map['formerTime'] as Timestamp?,
    );
  }

  @override
  String toString() {
    return 'SingleBalanceData(_amount: $_amount, _category: $_category, _currency: $_currency, _id: $_id, _name: $_name, _note: $_note, _repeatId: $_repeatId, _time: $_time, _formerTime: $_formerTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleBalanceData &&
        other._amount == _amount &&
        other._category == _category &&
        other._currency == _currency &&
        other._id == _id &&
        other._name == _name &&
        other._note == _note &&
        other._repeatId == _repeatId &&
        other._time == _time &&
        other._formerTime == _formerTime;
  }

  @override
  int get hashCode {
    return _amount.hashCode ^
        _category.hashCode ^
        _currency.hashCode ^
        _id.hashCode ^
        _name.hashCode ^
        _note.hashCode ^
        _repeatId.hashCode ^
        _time.hashCode ^
        _formerTime.hashCode;
  }

  num get amount => _amount;
  String get category => _category;
  String get currency => _currency;
  String get id => _id;
  String get name => _name;
  String? get note => _note;
  String? get repeatId => _repeatId;
  Timestamp get time => _time;
  Timestamp? get formerTime => _formerTime;
}
