//  Algorithm Provider - Handles Sort Algorithms used in displaying and filtering Data from Firebase
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial
//  (Refactored by damattl)

// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:linum/types/change_notifier_provider_builder.dart';
import 'package:linum/utilities/backend/in_between_timestamps.dart';
import 'package:linum/utilities/frontend/filters.dart';
import 'package:linum/utilities/frontend/sorters.dart';
import 'package:provider/provider.dart';

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

  void setCurrentShownMonth(DateTime inputMonth, {bool notify = false}) {
    _currentShownMonth = DateTime(inputMonth.year, inputMonth.month);
    _updateToCurrentShownMonth(notify: notify);
  }

  void resetCurrentShownMonth({bool notify = false}) {
    _currentShownMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _updateToCurrentShownMonth(notify: notify);
  }

  void nextMonth({bool notify = false}) {
    _currentShownMonth =
        DateTime(_currentShownMonth.year, _currentShownMonth.month + 1);
    _updateToCurrentShownMonth(notify: notify);
  }

  void previousMonth({bool notify = false}) {
    _currentShownMonth =
        DateTime(_currentShownMonth.year, _currentShownMonth.month - 1);

    _updateToCurrentShownMonth(notify: notify);
  }

  AlgorithmProvider() {
    resetCurrentShownMonth();
    _currentSorter = Sorters.timeNewToOld;
    _currentFilter = Filters.inBetween(timestampsFromNow());
  }

  void setCurrentSortAlgorithm(int Function(dynamic, dynamic) sorter,
      {bool notify = false,}) {
    _currentSorter = sorter;
    if (notify) {
      notifyListeners();
    }
  }

  void setCurrentFilterAlgorithm(bool Function(dynamic) filter, {bool notify = false}) {
    _currentFilter = filter;
    if (notify) {
      notifyListeners();
    }
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

  void _updateToCurrentShownMonth({bool notify = false}) {
    if (currentShownMonth.month == DateTime.now().month &&
        currentShownMonth.year == DateTime.now().year) {
      setCurrentFilterAlgorithm(
        Filters.inBetween(timestampsFromNow()),
        notify: notify,
      );
    } else {
      setCurrentFilterAlgorithm(
        Filters.inBetween(timestampsFromCurrentShownDate(currentShownMonth)),
        notify: notify,
      );
    }
  }

  static ChangeNotifierProviderBuilder builder() {
      return (BuildContext context, {bool testing = false}) {
        return ChangeNotifierProvider<AlgorithmProvider>(
          create: (_) => AlgorithmProvider(),
          lazy: false,
        );
      };
  }
}
