import 'package:flutter/material.dart';

/// Classes that are BalanceDataListView have to create a ListView using the addBalanceData function
abstract class BalanceDataListView {
  /// <summary> The function gets all balanceData provided as parameter.
  /// It will fill the ListView using that data.
  /// @balanceData Mapped Data from the Balance
  /// It has the following structure:
  /// [singleBalance1, singleBalance2, singleBalance3...]
  /// with singleBalance1 having the structure:
  /// singleBalance =
  /// {
  ///   amount: <Number>
  ///   category: <String>
  ///   currency: <String> (from the currency list in the converter collection)
  ///   name: <String>
  ///   time: <Timestamp>
  /// }
  addBalanceData(List<dynamic> balanceData);

  /// Return the styled ListView that contains all the balanceData
  ListView get listview;
}
