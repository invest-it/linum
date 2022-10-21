import 'package:cloud_firestore/cloud_firestore.dart';

class ChangedRepeatedBalanceData {
  num? amount;
  String? category;
  String? currency;
  String? name;
  String? note;
  Timestamp? time;
  bool? deleted;

  ChangedRepeatedBalanceData({
    this.amount,
    this.category,
    this.currency,
    this.name,
    this.note,
    this.time,
    this.deleted,
  });

  factory ChangedRepeatedBalanceData.fromMap(Map<String, dynamic> map) {
    return ChangedRepeatedBalanceData(
      amount: map['amount'] as num?,
      category: map['category'] as String?,
      currency: map['currency'] as String?,
      name: map['name'] as String?,
      note: map['note'] as String?,
      time: map['time'] as Timestamp?,
      deleted: map['deleted'] as bool?,
    );
  }
}
