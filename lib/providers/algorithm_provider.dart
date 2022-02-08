import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// gives sort algorithm (later it will probably also have filter algorithm) and
/// all algorithm will have an active version instead of being static
/// so it is possible to have dynamic sort and filter algorithm
class AlgorithmProvider extends ChangeNotifier {
  late int Function(dynamic, dynamic) _currentSorter;

  late bool Function(dynamic) _currentFilter;

  bool Function(dynamic) get currentFilter => _currentFilter;

  int Function(dynamic, dynamic) get currentSorter => _currentSorter;

  late DateTime _currentShownMonth;

  DateTime get currentShownMonth => _currentShownMonth;

  void setCurrentShownMonth(DateTime inputMonth) {
    _currentShownMonth = DateTime(inputMonth.year, inputMonth.month);
  }

  void resetCurrentShownMonth() {
    _currentShownMonth =
        DateTime(DateTime.now().year, (DateTime.now().month) + 1)
            .subtract(Duration(microseconds: 1));
  }

  void nextMonth() {
    _currentShownMonth =
        DateTime(_currentShownMonth.year, _currentShownMonth.month + 1);
  }

  void previousMonth() {
    _currentShownMonth =
        DateTime(_currentShownMonth.year, _currentShownMonth.month - 1);
  }

  AlgorithmProvider() {
    resetCurrentShownMonth();
    _currentSorter = timeNewToOld;
    _currentFilter = AlgorithmProvider.inBetween(
      Timestamp.fromDate(DateTime(
        DateTime.now().year,
        DateTime.now().month,
      ).subtract(Duration(microseconds: 1))),
      Timestamp.fromDate(DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
      )),
    );
  }

  void setCurrentSortAlgorithm(int Function(dynamic, dynamic) sorter) {
    _currentSorter = sorter;
    notifyListeners();
  }

  void setCurrentFilterAlgorithm(bool Function(dynamic) filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setCurrentFilterAlgorithmSilently(bool Function(dynamic) filter) {
    _currentFilter = filter;
  }

  /// returns a new sort algorithm. It sorts using the first
  /// sort algorithm, but if the sort algorithm says 0 the next
  /// sort algorithm will be used and so one. If every
  /// sort algorithm says 0, it will return 0.
  static int Function(dynamic, dynamic) combineSorter(
      List<int Function(dynamic, dynamic)> sorterList) {
    if (sorterList.length == 0) {
      return (a, b) => 0;
    }
    int Function(dynamic, dynamic) returnFunc = (a, b) {
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
  static bool Function(dynamic) combineFilterStrict(
      List<bool Function(dynamic)> filterList) {
    if (filterList.length == 0) {
      return (a) => false;
    }
    bool Function(dynamic) returnFunc = (a) {
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
      List<bool Function(dynamic)> filterList) {
    if (filterList.length == 0) {
      return (a) => false;
    }
    bool Function(dynamic) returnFunc = (a) {
      for (int i = 0; i < filterList.length; i++) {
        if (!filterList[i](a)) {
          return false;
        }
      }
      return true;
    };

    return returnFunc;
  }

  static int amountLeastToMost(dynamic a, dynamic b) {
    return a["amount"].compareTo(b["amount"]);
  }

  static int amountMostToLeast(dynamic b, dynamic a) {
    return a["amount"].compareTo(b["amount"]);
  }

  static int categoryAlphabetically(dynamic a, dynamic b) {
    return a["category"].compareTo(b["category"]);
  }

  static int categoryAlphabeticallyReversed(dynamic b, dynamic a) {
    return a["category"].compareTo(b["category"]);
  }

  static int nameAlphabetically(dynamic a, dynamic b) {
    return a["name"].compareTo(b["name"]);
  }

  static int nameAlphabeticallyReversed(dynamic b, dynamic a) {
    return a["name"].compareTo(b["name"]);
  }

  static int timeNewToOld(dynamic a, dynamic b) {
    return b["time"].compareTo(a["time"]);
  }

  static int timeOldToNew(dynamic b, dynamic a) {
    return a["time"].compareTo(b["time"]);
  }

  static bool noFilter(dynamic a) {
    return false;
  }

  static bool Function(dynamic) newerThan(Timestamp timestamp) {
    return (dynamic a) => (a["time"].compareTo(timestamp) <= 0);
  }

  static bool Function(dynamic) olderThan(Timestamp timestamp) {
    return (dynamic a) => (a["time"].compareTo(timestamp) >= 0);
  }

  static bool Function(dynamic) inBetween(
      Timestamp timestamp1, Timestamp timestamp2) {
    return (dynamic a) =>
        (a["time"].compareTo(timestamp1) <= 0) ||
        (a["time"].compareTo(timestamp2) >= 0);
  }

  static bool Function(dynamic) amountMoreThan(num amount) {
    return (dynamic a) => (a["amount"].compareTo(amount) > 0);
  }

  static bool Function(dynamic) amountAtLeast(num amount) {
    return (dynamic a) => (a["amount"].compareTo(amount) >= 0);
  }

  static bool Function(dynamic) amountLessThan(num amount) {
    return (dynamic a) => (a["amount"].compareTo(amount) < 0);
  }

  static bool Function(dynamic) amountAtMost(num amount) {
    return (dynamic a) => (a["amount"].compareTo(amount) <= 0);
  }
}
