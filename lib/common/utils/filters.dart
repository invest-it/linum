//  Filter Functions - Filters input to certain criteria
//
//  Author: SoTBurst
//  Co-Author: damattl
//  (Refactored)

// will be removed when filters will only be used on SingleBalanceData
// ignore_for_file: avoid_dynamic_calls

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:linum/core/balance/models/transaction.dart';
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
        _mapToTransaction(a).date.compareTo(timestamp) >= 0;
  }

  static bool Function(dynamic) olderThan(Timestamp timestamp) {
    return (dynamic a) =>
        _mapToTransaction(a).date.compareTo(timestamp) <= 0;
  }

  static bool Function(dynamic) inBetween(
    Tuple2 <Timestamp,  Timestamp> timestamps,
  ) {
    return (dynamic a) =>
        _mapToTransaction(a).date.compareTo(timestamps.item1) <= 0 ||
        _mapToTransaction(a).date.compareTo(timestamps.item2) >= 0;
  }

  static bool Function(dynamic) amountMoreThan(num amount) {
    return (dynamic a) => _mapToTransaction(a).amount.compareTo(amount) > 0;
  }

  static bool Function(dynamic) amountAtLeast(num amount) {
    return (dynamic a) =>
        _mapToTransaction(a).amount.compareTo(amount) >= 0;
  }

  static bool Function(dynamic) amountLessThan(num amount) {
    return (dynamic a) => _mapToTransaction(a).amount.compareTo(amount) < 0;
  }

  static bool Function(dynamic) amountAtMost(num amount) {
    return (dynamic a) =>
        _mapToTransaction(a).amount.compareTo(amount) <= 0;
  }

  static Transaction _mapToTransaction(dynamic a) {
    if (a is Map<String, dynamic>) {
      return Transaction.fromMap(a);
    }
    return a as Transaction;
  }
}
