//  Balance Data List View (Abstract) - Class that comes with a built-in function to retrieve the BalanceData
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/models/transaction.dart';

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
  void setSingleBalanceData(
    List<Transaction> balanceData, {
    required BuildContext context,
    bool error = false,
  });

  void setRepeatedBalanceData(
    List<SerialTransaction> balanceData, {
    required BuildContext context,
    bool error = false,
  });

  /// Return the styled ListView that contains all the balanceData
  ListView get listview;
}
