//  Sort Functions - Helper Function to Sort Inputs by certain criteria
//
//  Author: SoTBurst
//  Co-Author: damattl
//  (Refactored)

import 'package:cloud_firestore/cloud_firestore.dart';

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
    return ((a as Map<String, dynamic>)["amount"] as num)
        .compareTo((b as Map<String, dynamic>)["amount"] as num);
  }

  static int amountMostToLeast(dynamic b, dynamic a) {
    return ((a as Map<String, dynamic>)["amount"] as num)
        .compareTo((b as Map<String, dynamic>)["amount"] as num);
  }

  static int categoryAlphabetically(dynamic a, dynamic b) {
    return ((a as Map<String, dynamic>)["category"] as String)
        .compareTo((b as Map<String, dynamic>)["category"] as String);
  }

  static int categoryAlphabeticallyReversed(dynamic b, dynamic a) {
    return ((a as Map<String, dynamic>)["category"] as String)
        .compareTo((b as Map<String, dynamic>)["category"] as String);
  }

  static int nameAlphabetically(dynamic a, dynamic b) {
    return ((a as Map<String, dynamic>)["name"] as String)
        .compareTo((b as Map<String, dynamic>)["name"] as String);
  }

  static int nameAlphabeticallyReversed(dynamic b, dynamic a) {
    return ((a as Map<String, dynamic>)["name"] as String)
        .compareTo((b as Map<String, dynamic>)["name"] as String);
  }

  static int timeNewToOld(dynamic a, dynamic b) {
    return ((b as Map<String, dynamic>)["time"] as Timestamp)
        .compareTo((a as Map<String, dynamic>)["time"] as Timestamp);
  }

  static int timeOldToNew(dynamic b, dynamic a) {
    return ((a as Map<String, dynamic>)["time"] as Timestamp)
        .compareTo((b as Map<String, dynamic>)["time"] as Timestamp);
  }

}
