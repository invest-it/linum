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
    final balanceData = map['balanceData'] as List<Map<String, dynamic>>;
    final repeatedBalance = map['repeatedBalance'] as List<Map<String, dynamic>>;
    return BalanceDocument(
      balanceData: balanceData.map((Map<String, dynamic> data) => SingleBalanceData.fromMap(data)).toList(),
      repeatedBalance: repeatedBalance.map((Map<String, dynamic> data) => RepeatedBalanceData.fromMap(data)).toList(),
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
