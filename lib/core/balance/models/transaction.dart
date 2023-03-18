//  Single Balance Data - Model for defining information used by a card that is NOT a copy of an original repeated transaction ("Single Transacton").
//
//  Author: SoTBurst
//  Co-Author: n/a //TODO @SoTBurst might be useful to train more people on this
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/features/currencies/models/exchange_rate_info.dart';
import 'package:uuid/uuid.dart';

class Transaction {
  final num amount;
  final String? category;
  final String currency;
  final String id;
  final String name;
  final String? note;
  final String? repeatId;
  final Timestamp time;
  final Timestamp? formerTime; // strictly for changed repeatables
  ExchangeRateInfo? rateInfo;

  Transaction({
    required this.amount,
    this.category,
    required this.currency,
    String? id,
    required this.name,
    this.note,
    this.repeatId,
    required this.time,
    this.formerTime,
    this.rateInfo,
  })  : id = id ?? const Uuid().v4();

  Transaction copyWith({
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
    return Transaction(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      repeatId: repeatId ?? this.repeatId,
      time: time ?? this.time,
      formerTime: formerTime ?? this.formerTime,
      rateInfo: rateInfo,
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
      'repeatId': repeatId,
      'time': time,
      'formerTime': formerTime,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
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
    return 'Transaction(amount: $amount, category: $category, currency: $currency, id: $id, name: $name, note: $note, repeatId: $repeatId, time: $time, formerTime: $formerTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.amount == amount &&
        other.category == category &&
        other.currency == currency &&
        other.id == id &&
        other.name == name &&
        other.note == note &&
        other.repeatId == repeatId &&
        other.time == time &&
        other.formerTime == formerTime;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        category.hashCode ^
        currency.hashCode ^
        id.hashCode ^
        name.hashCode ^
        note.hashCode ^
        repeatId.hashCode ^
        time.hashCode ^
        formerTime.hashCode;
  }

}
