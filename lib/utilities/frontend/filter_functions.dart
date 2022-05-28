//  Filter Functions - Filters input to certain criteria
//
//  Author: SoTBurst
//  Co-Author: damattl
//  (Refactored)

import 'package:cloud_firestore/cloud_firestore.dart';

/// returns a new sort algorithm. It sorts using the first
/// sort algorithm, but if the sort algorithm says 0 the next
/// sort algorithm will be used and so one. If every
/// sort algorithm says 0, it will return 0.
int Function(dynamic, dynamic) combineSorter(
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

/// Returns a filter that will remove an element if one filter doesnt let it pass
bool Function(dynamic) combineFilterStrict(
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
bool Function(dynamic) combineFilterGentle(
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

bool noFilter(dynamic a) {
  return false;
}

bool Function(dynamic) newerThan(Timestamp timestamp) {
  return (dynamic a) =>
      ((a as Map<String, dynamic>)["time"] as Timestamp).compareTo(timestamp) <=
      0;
}

bool Function(dynamic) olderThan(Timestamp timestamp) {
  return (dynamic a) =>
      ((a as Map<String, dynamic>)["time"] as Timestamp).compareTo(timestamp) >=
      0;
}

bool Function(dynamic) inBetween(
  Timestamp timestamp1,
  Timestamp timestamp2,
) {
  return (dynamic a) =>
      ((a as Map<String, dynamic>)["time"] as Timestamp)
              .compareTo(timestamp1) <=
          0 ||
      (a["time"] as Timestamp).compareTo(timestamp2) >= 0;
}

bool Function(dynamic) amountMoreThan(num amount) {
  return (dynamic a) =>
      ((a as Map<String, dynamic>)["amount"] as num).compareTo(amount) > 0;
}

bool Function(dynamic) amountAtLeast(num amount) {
  return (dynamic a) =>
      ((a as Map<String, dynamic>)["amount"] as num).compareTo(amount) >= 0;
}

bool Function(dynamic) amountLessThan(num amount) {
  return (dynamic a) =>
      ((a as Map<String, dynamic>)["amount"] as num).compareTo(amount) < 0;
}

bool Function(dynamic) amountAtMost(num amount) {
  return (dynamic a) =>
      ((a as Map<String, dynamic>)["amount"] as num).compareTo(amount) <= 0;
}
