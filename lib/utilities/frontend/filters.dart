//  Filter Functions - Filters input to certain criteria
//
//  Author: SoTBurst
//  Co-Author: damattl
//  (Refactored)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class Filters {
  /// Returns a filter that will remove an element if one filter doesnt let it pass
  static bool Function(dynamic) combineFilterStrict(
      List<bool Function(dynamic)> filterList,
      ) {
    if (filterList.isEmpty) {
      return (a) => false;
    }
    final bool Function(dynamic) returnFunc = (a) {
      for (int i = 0; i < filterList.length; i++) {
        if (filterList[i](a)) {
          return true;
        }
      }
      return false;
    };

    return returnFunc;
  }

  /// Returns a filter that will remove an element only if every filter doesnt let it pass
  static bool Function(dynamic) combineFilterGentle(
      List<bool Function(dynamic)> filterList,
      ) {
    if (filterList.isEmpty) {
      return (a) => false;
    }
    final bool Function(dynamic) returnFunc = (a) {
      for (int i = 0; i < filterList.length; i++) {
        if (!filterList[i](a)) {
          return false;
        }
      }
      return true;
    };

    return returnFunc;
  }

  static bool noFilter(dynamic a) {
    return false;
  }

  static bool Function(dynamic) newerThan(Timestamp timestamp) {
    return (dynamic a) =>
    ((a as Map<String, dynamic>)["time"] as Timestamp).compareTo(timestamp) <=
        0;
  }

  static bool Function(dynamic) olderThan(Timestamp timestamp) {
    return (dynamic a) =>
    ((a as Map<String, dynamic>)["time"] as Timestamp).compareTo(timestamp) >=
        0;
  }

  static bool Function(dynamic) inBetween(Tuple2<Timestamp, Timestamp> timestamps) {
    return (dynamic a) =>
    ((a as Map<String, dynamic>)["time"] as Timestamp)
        .compareTo(timestamps.item1) <=
        0 ||
        (a["time"] as Timestamp).compareTo(timestamps.item2) >= 0;
  }

  static bool Function(dynamic) amountMoreThan(num amount) {
    return (dynamic a) =>
    ((a as Map<String, dynamic>)["amount"] as num).compareTo(amount) > 0;
  }

  static bool Function(dynamic) amountAtLeast(num amount) {
    return (dynamic a) =>
    ((a as Map<String, dynamic>)["amount"] as num).compareTo(amount) >= 0;
  }

  static bool Function(dynamic) amountLessThan(num amount) {
    return (dynamic a) =>
    ((a as Map<String, dynamic>)["amount"] as num).compareTo(amount) < 0;
  }

  static bool Function(dynamic) amountAtMost(num amount) {
    return (dynamic a) =>
    ((a as Map<String, dynamic>)["amount"] as num).compareTo(amount) <= 0;
  }
}
