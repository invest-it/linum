import 'dart:developer';

import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/single_balance_data.dart';


class BalanceDocument {
  final List<SingleBalanceData> balanceData;
  final List<RepeatedBalanceData> repeatedBalance;
  Map<String, dynamic> settings;

  BalanceDocument({
    List<SingleBalanceData>? balanceData,
    List<RepeatedBalanceData>? repeatedBalance,
    Map<String, dynamic>? settings,
  }) :
    balanceData = balanceData ?? <SingleBalanceData>[],
    repeatedBalance = repeatedBalance ?? <RepeatedBalanceData>[],
    settings = settings ?? <String, dynamic>{};


  factory BalanceDocument.fromMap(Map<String, dynamic> map) {
    log("BalanceData: ${map['balanceData'].toString()}");
    final rawBalanceData = map['balanceData'] as List<dynamic>;
    final balanceData = rawBalanceData.map((data) => SingleBalanceData.fromMap(data as Map<String, dynamic>)).toList();
    final rawRepeatedBalance = map['repeatedBalance'] as List<dynamic>;
    final repeatedBalance = rawRepeatedBalance.map((data) => RepeatedBalanceData.fromMap(data as Map<String, dynamic>)).toList();
    return BalanceDocument(
      balanceData: balanceData,
      repeatedBalance: repeatedBalance,
      settings: map['settings'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balanceData': balanceData.map((e) => e.toMap()),
      'repeatedBalance': balanceData.map((e) => e.toMap()),
      'settings': settings,
    };
  }
}
