//  Transaction - Model for defining information used by a card that is NOT a copy of an original repeated transaction ("Single Transacton").
//
//  Author: SoTBurst
//  Co-Author: damattl
//

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:linum/features/currencies/core/data/models/exchange_rate_info.dart';
import 'package:uuid/uuid.dart';

class Transaction {
  final num amount;
  final String category;
  final String currency;
  final String id;
  final String name;
  final String? note;
  final String? repeatId;
  final DateTime date;
  final DateTime? formerDate; // strictly for changed repeatables
  ExchangeRateInfo? rateInfo;

  Transaction({
    required this.amount,
    required this.category,
    required this.currency,
    String? id,
    required this.name,
    this.note,
    this.repeatId,
    required this.date,
    this.formerDate,
    this.rateInfo,
  })  : id = id ?? const Uuid().v4();

  bool isIncome() {
    return amount > 0;
  }

  num get amountInStandardCurrency {
    return rateInfo?.convertAmount(amount) ?? amount;
  }

  Transaction copyWith({
    num? amount,
    String? category,
    String? currency,
    String? id,
    String? name,
    String? note,
    String? repeatId,
    DateTime? date,
    DateTime? formerDate,
  }) {
    return Transaction(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      repeatId: repeatId ?? this.repeatId,
      date: date ?? this.date,
      formerDate: formerDate ?? this.formerDate,
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
      'time': date,
      'formerTime': formerDate,
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
      'repeatId': repeatId,
      'time': Timestamp.fromDate(date),
      'formerTime': formerDate != null ? Timestamp.fromDate(formerDate!) : null,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    var category = map['category'] as String?;
    final amount = map['amount'] as num;

    if (category == null) {
      if (amount < 0) {
        category = "none-expense";
      } else {
        category = "none-income";
      }
    }
    return Transaction(
      amount: amount,
      category: category,
      currency: map['currency'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      note: map['note'] as String?,
      repeatId: map['repeatId'] as String?,
      date: map['time'] as DateTime,
      formerDate: map['formerTime'] as DateTime?,
    );
  }

  factory Transaction.fromFirestore(Map<String, dynamic> map) {
    var category = map['category'] as String?;
    final amount = map['amount'] as num;

    if (category == null) {
      if (amount < 0) {
        category = "none-expense";
      } else {
        category = "none-income";
      }
    }
    return Transaction(
      amount: amount,
      category: category,
      currency: map['currency'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      note: map['note'] as String?,
      repeatId: map['repeatId'] as String?,
      date: (map['time'] as Timestamp).toDate(),
      formerDate: (map['formerTime'] as Timestamp?)?.toDate(),
    );
  }

  @override
  String toString() {
    return 'Transaction(amount: $amount, category: $category, currency: $currency, id: $id, name: $name, note: $note, repeatId: $repeatId, time: $date, formerDate: $formerDate)';
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
        other.date == date &&
        other.formerDate == formerDate;
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
        date.hashCode ^
        formerDate.hashCode;
  }

}
