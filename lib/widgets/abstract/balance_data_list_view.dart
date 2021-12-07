import 'package:flutter/material.dart';

abstract class BalanceDataListView {
  /// <summary> The function gets all balanceData provided as parameter.
  /// It will fill the ListView using that data.
  /// @balanceData Mapped Data from the Balance (Format not 100% clear yet)
  addBalanceData(List<dynamic> balanceData);

  ListView get listview;
}
