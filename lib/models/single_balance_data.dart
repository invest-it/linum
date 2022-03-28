import 'package:cloud_firestore/cloud_firestore.dart';

class SingleBalanceData {
  final num _amount;
  final String _category;
  final String _currency;
  final String _id;
  final String _name;
  final String? _repeatId;
  final Timestamp _time;

  SingleBalanceData({
    required num amount,
    required String category,
    required String currency,
    required String id,
    required String name,
    String? repeatId,
    required Timestamp time,
  })  : _amount = amount,
        _category = category,
        _currency = currency,
        _id = id,
        _name = name,
        _repeatId = repeatId,
        _time = time;

  SingleBalanceData copyWith({
    num? amount,
    String? category,
    String? currency,
    String? id,
    String? name,
    String? repeatId,
    Timestamp? time,
  }) {
    return SingleBalanceData(
      amount: amount ?? _amount,
      category: category ?? _category,
      currency: currency ?? _currency,
      id: id ?? _id,
      name: name ?? _name,
      repeatId: repeatId ?? _repeatId,
      time: time ?? _time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': _amount,
      'category': _category,
      'currency': _currency,
      'id': _id,
      'name': _name,
      'repeatId': _repeatId,
      'time': _time,
    };
  }

  factory SingleBalanceData.fromMap(Map<String, dynamic> map) {
    return SingleBalanceData(
      amount: map['amount'] as num,
      category: map['category'] as String,
      currency: map['currency'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      repeatId: map['repeatId'] as String?,
      time: map['time'] as Timestamp,
    );
  }

  @override
  String toString() {
    return 'SingleBalanceData(_amount: $_amount, _category: $_category, _currency: $_currency, _id: $_id, _name: $_name, _repeatId: $_repeatId, _time: $_time)';
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
        other._repeatId == _repeatId &&
        other._time == _time;
  }

  @override
  int get hashCode {
    return _amount.hashCode ^
        _category.hashCode ^
        _currency.hashCode ^
        _id.hashCode ^
        _name.hashCode ^
        _repeatId.hashCode ^
        _time.hashCode;
  }
}
