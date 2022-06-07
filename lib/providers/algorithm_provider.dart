//  Algorithm Provider - Handles Sort Algorithms used in displaying and filtering Data from Firebase
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial
//  (Refactored by damattl)

// ignore_for_file: avoid_dynamic_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/filters.dart';
import 'package:linum/utilities/frontend/sorters.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

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
    _updateToCurrentShownMonthSilently();
  }

  void resetCurrentShownMonth() {
    _currentShownMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _updateToCurrentShownMonthSilently();
  }

  void nextMonth() {
    _currentShownMonth =
        DateTime(_currentShownMonth.year, _currentShownMonth.month + 1);
    _updateToCurrentShownMonthSilently();
  }

  void previousMonth() {
    _currentShownMonth =
        DateTime(_currentShownMonth.year, _currentShownMonth.month - 1);

    _updateToCurrentShownMonthSilently();
  }

  AlgorithmProvider() {
    resetCurrentShownMonth();
    _currentSorter = Sorters.timeNewToOld;
    _currentFilter = Filters.inBetween(
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

  void _updateToCurrentShownMonthSilently() {
    if (currentShownMonth.month == DateTime.now().month &&
        currentShownMonth.year == DateTime.now().year) {
      setCurrentFilterAlgorithm(
        Filters.inBetween(
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
        ),
      );
    } else {
      setCurrentFilterAlgorithm(
        Filters.inBetween(
          Timestamp.fromDate(
            currentShownMonth.subtract(const Duration(microseconds: 1)),
          ),
          Timestamp.fromDate(
            DateTime(
              currentShownMonth.year,
              currentShownMonth.month + 1,
            ),
          ),
        ),
      );
    }
  }


  static SingleChildWidget provider(BuildContext context, {bool testing = false}) {
    return ChangeNotifierProvider<AlgorithmProvider>(
      create: (_) => AlgorithmProvider(),
      lazy: false,
    );
  }
}
