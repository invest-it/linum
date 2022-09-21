//  Sort Functions - Helper Function to Sort Inputs by certain criteria
//
//  Author: SoTBurst
//  Co-Author: damattl
//  (Refactored)

// will be removed when sorters will only be used on SingleBalanceData
// ignore_for_file: avoid_dynamic_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/models/single_balance_data.dart';

class Sorters {
  /// returns a new sort algorithm. It sorts using the first
  /// sort algorithm, but if the sort algorithm says 0 the next
  /// sort algorithm will be used and so one. If every
  /// sort algorithm says 0, it will return 0.
  static int Function(dynamic, dynamic) combineSorter(
    List<int Function(dynamic, dynamic)> sorterList,
  ) {
    if (sorterList.isEmpty) {
      return (a, b) => 0;
    }
    final int Function(dynamic, dynamic) returnFunc = (a, b) {
      for (int i = 0; i < sorterList.length; i++) {
        if (sorterList[i](a, b) != 0) {
          return sorterList[i](a, b);
        }
      }
      return 0;
    };

    return returnFunc;
  }

  static int amountLeastToMost(dynamic a, dynamic b) {
    // maybe filter is used on maps
    // if can be deleted later
    if (a is SingleBalanceData && b is SingleBalanceData) {
      return (a.amount).compareTo(b.amount);
    }

    return (a["amount"] as num).compareTo(b["amount"] as num);
  }

  static int amountMostToLeast(dynamic b, dynamic a) {
    if (a is SingleBalanceData && b is SingleBalanceData) {
      return (a.amount).compareTo(b.amount);
    }
    return (a["amount"] as num).compareTo(b["amount"] as num);
  }

  static int categoryAlphabetically(dynamic a, dynamic b) {
    if (a is SingleBalanceData && b is SingleBalanceData) {
      return (a.category).compareTo(b.category);
    }
    return (a["category"] as String).compareTo(b["category"] as String);
  }

  static int categoryAlphabeticallyReversed(dynamic b, dynamic a) {
    if (a is SingleBalanceData && b is SingleBalanceData) {
      return (a.category).compareTo(b.category);
    }
    return (a["category"] as String).compareTo(b["category"] as String);
  }

  static int nameAlphabetically(dynamic a, dynamic b) {
    if (a is SingleBalanceData && b is SingleBalanceData) {
      return (a.name).compareTo(b.name);
    }
    return (a["name"] as String).compareTo(b["name"] as String);
  }

  static int nameAlphabeticallyReversed(dynamic b, dynamic a) {
    if (a is SingleBalanceData && b is SingleBalanceData) {
      return (a.name).compareTo(b.name);
    }
    return (a["name"] as String).compareTo(b["name"] as String);
  }

  static int timeNewToOld(dynamic a, dynamic b) {
    if (a is SingleBalanceData && b is SingleBalanceData) {
      return (a.time).compareTo(b.time);
    }
    return (b["time"] as Timestamp).compareTo(a["time"] as Timestamp);
  }

  static int timeOldToNew(dynamic b, dynamic a) {
    if (a is SingleBalanceData && b is SingleBalanceData) {
      return (a.time).compareTo(b.time);
    }
    return (a["time"] as Timestamp).compareTo(b["time"] as Timestamp);
  }

  static SingleBalanceData _mapToSinglebalance(dynamic a) {
    if (a is Map<String, dynamic>) {
      return SingleBalanceData.fromMap(a);
    }
    return a as SingleBalanceData;
  }
}
