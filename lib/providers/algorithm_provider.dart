// ignore_for_file: avoid_dynamic_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/filter_functions.dart';
import 'package:linum/utilities/frontend/sort_functions.dart';

/// gives sort algorithm (later it will probably also have filter algorithm) and
/// all algorithm will have an active version instead of being static
/// so it is possible to have dynamic sort and filter algorithm
class AlgorithmProvider extends ChangeNotifier {
  late int Function(dynamic, dynamic) _currentSorter;

  late bool Function(dynamic) _currentFilter;

  bool Function(dynamic) get currentFilter => _currentFilter;

  int Function(dynamic, dynamic) get currentSorter => _currentSorter;

  late DateTime _currentShownMonth;

  int _balanceDataUnnoticedChanges = 0;

  DateTime get currentShownMonth => _currentShownMonth;

  @override
  void notifyListeners() {
    super.notifyListeners();
    _balanceDataUnnoticedChanges++;
  }

  void setCurrentShownMonth(DateTime inputMonth) {
    _currentShownMonth = DateTime(inputMonth.year, inputMonth.month);
  }

  void resetCurrentShownMonth() {
    _currentShownMonth = DateTime(DateTime.now().year, DateTime.now().month);
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
    _currentFilter = inBetween(
      Timestamp.fromDate(
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
        ).subtract(const Duration(microseconds: 1)),
      ),
      Timestamp.fromDate(
        DateTime(
          DateTime.now().year,
          DateTime.now().month + 1,
        ),
      ),
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

  int get balanceDataUnnoticedChanges => _balanceDataUnnoticedChanges;

  bool get balanceNeedsNotice => balanceDataUnnoticedChanges > 0;

  void balanceDataNotice() {
    _balanceDataUnnoticedChanges--;
    if (_balanceDataUnnoticedChanges < 0) {
      _balanceDataUnnoticedChanges = 0;
    }
  }

  // TODO: Refactor the rest of the file

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

  static int amountLeastToMost(dynamic a, dynamic b) {
    return (a["amount"] as num).compareTo(b["amount"] as num);
  }

  static int amountMostToLeast(dynamic b, dynamic a) {
    return (a["amount"] as num).compareTo(b["amount"] as num);
  }

  static int categoryAlphabetically(dynamic a, dynamic b) {
    return (a["category"] as String).compareTo(b["category"] as String);
  }

  static int categoryAlphabeticallyReversed(dynamic b, dynamic a) {
    return (a["category"] as String).compareTo(b["category"] as String);
  }

  static int nameAlphabetically(dynamic a, dynamic b) {
    return (a["name"] as String).compareTo(b["name"] as String);
  }

  static int nameAlphabeticallyReversed(dynamic b, dynamic a) {
    return (a["name"] as String).compareTo(b["name"] as String);
  }

  static int timeNewToOld(dynamic a, dynamic b) {
    return (b["time"] as Timestamp).compareTo(a["time"] as Timestamp);
  }

  static int timeOldToNew(dynamic b, dynamic a) {
    return (a["time"] as Timestamp).compareTo(b["time"] as Timestamp);
  }

  static bool noFilter(dynamic a) {
    return false;
  }

  static bool Function(dynamic) newerThan(Timestamp timestamp) {
    return (dynamic a) => (a["time"] as Timestamp).compareTo(timestamp) <= 0;
  }

  static bool Function(dynamic) olderThan(Timestamp timestamp) {
    return (dynamic a) => (a["time"] as Timestamp).compareTo(timestamp) >= 0;
  }

  static bool Function(dynamic) inBetween(
    Timestamp timestamp1,
    Timestamp timestamp2,
  ) {
    return (dynamic a) =>
        (a["time"] as Timestamp).compareTo(timestamp1) <= 0 ||
        (a["time"] as Timestamp).compareTo(timestamp2) >= 0;
  }

  static bool Function(dynamic) amountMoreThan(num amount) {
    return (dynamic a) => (a["amount"] as num).compareTo(amount) > 0;
  }

  static bool Function(dynamic) amountAtLeast(num amount) {
    return (dynamic a) => (a["amount"] as num).compareTo(amount) >= 0;
  }

  static bool Function(dynamic) amountLessThan(num amount) {
    return (dynamic a) => (a["amount"] as num).compareTo(amount) < 0;
  }

  static bool Function(dynamic) amountAtMost(num amount) {
    return (dynamic a) => (a["amount"] as num).compareTo(amount) <= 0;
  }
}
