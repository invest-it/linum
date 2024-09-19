import 'package:cloud_firestore/cloud_firestore.dart';

class ChangedTransaction {
  num? amount;
  String? category;
  String? currency;
  String? name;
  String? note;
  DateTime? date;
  bool? deleted;

  ChangedTransaction({
    this.amount,
    this.category,
    this.currency,
    this.name,
    this.note,
    this.date,
    this.deleted,
  });

  factory ChangedTransaction.fromMap(Map<String, dynamic> map) {
    return ChangedTransaction(
      amount: map['amount'] as num?,
      category: map['category'] as String?,
      currency: map['currency'] as String?,
      name: map['name'] as String?,
      note: map['note'] as String?,
      date: map['time'] as DateTime?,
      deleted: map['deleted'] as bool?,
    );
  }

  factory ChangedTransaction.fromFirestore(Map<String, dynamic> map) {
    return ChangedTransaction(
      amount: map['amount'] as num?,
      category: map['category'] as String?,
      currency: map['currency'] as String?,
      name: map['name'] as String?,
      note: map['note'] as String?,
      date: (map['time'] as Timestamp?)?.toDate(),
      deleted: map['deleted'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'currency': currency,
      'name': name,
      'note': note,
      'time': date,
      'deleted': deleted,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'category': category,
      'currency': currency,
      'name': name,
      'note': note,
      'time': date != null ? Timestamp.fromDate(date!) : null,
      'deleted': deleted,
    };
  }
}
