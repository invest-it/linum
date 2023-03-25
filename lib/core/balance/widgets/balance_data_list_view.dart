//  Balance Data List View (Abstract) - Class that comes with a built-in function to retrieve the BalanceData
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';

/// Classes that are BalanceDataListView have to create a ListView using the addBalanceData function
abstract class BalanceDataListView {
  /// <summary> The function gets all balanceData provided as parameter.
  /// It will fill the ListView using that data.
  /// @balanceData Mapped Data from the Balance
  /// It has the following structure:
  /// [transaction1, transaction2, transaction3...]
  /// with transaction1 having the structure:
  /// transaction =
  /// {
  ///   amount: <Number>
  ///   category: <String>
  ///   currency: <String> (from the currency list in the converter collection)
  ///   name: <String>
  ///   date: <Timestamp>
  /// }
  void setTransactions(
    List<Transaction> transactions, {
    required BuildContext context,
    bool error = false,
  });

  void setSerialTransactions(
    List<SerialTransaction> transactions, {
    required BuildContext context,
    bool error = false,
  });

  /// Return the styled ListView that contains all the balanceData
  ListView get listview;
}
