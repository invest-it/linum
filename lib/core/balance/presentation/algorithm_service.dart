//  Algorithm Provider - Handles Sort Algorithms used in displaying and filtering Data from Firebase
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial
//  (Refactored by damattl)

// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:linum/common/utils/filters.dart';
import 'package:linum/common/utils/in_between_timestamps.dart';
import 'package:linum/common/utils/sorters.dart';
import 'package:linum/core/balance/domain/models/algorithm_state.dart';

/// gives sort algorithm (later it will probably also have filter algorithm) and
/// all algorithm will have an active version instead of being static
/// so it is possible to have dynamic sort and filter algorithm
class AlgorithmService extends ChangeNotifier {
  int _balanceDataUnnoticedChanges = 0;

  late AlgorithmState _state;
  AlgorithmState get state => _state;
  set state(AlgorithmState newState)  {
    _state = newState;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    _balanceDataUnnoticedChanges++;
  }

  void setCurrentShownMonth(DateTime inputMonth, {bool notify = false}) {
    _state = _state.copyWith(
        shownMonth: DateTime(inputMonth.year, inputMonth.month),
    );
    _updateToCurrentShownMonth(notify: notify);
  }

  void resetCurrentShownMonth({bool notify = false}) {
    _state = _state.copyWith(
      shownMonth: DateTime(DateTime.now().year, DateTime.now().month),
    );
    _updateToCurrentShownMonth(notify: notify);
  }

  void nextMonth({bool notify = false}) {
    _state = _state.copyWith(
      shownMonth: DateTime(_state.shownMonth.year, _state.shownMonth.month + 1),
    );
    _updateToCurrentShownMonth(notify: notify);
  }

  void previousMonth({bool notify = false}) {
    _state = _state.copyWith(
      shownMonth: DateTime(_state.shownMonth.year, _state.shownMonth.month - 1),
    );
    _updateToCurrentShownMonth(notify: notify);
  }

  AlgorithmService() {
    _state = AlgorithmState(
        sorter: Sorters.dateNewToOld,
        filter: Filters.inBetween(timestampsFromNow()),
        shownMonth: DateTime(DateTime.now().year, DateTime.now().month),
    );
  }

  void setCurrentSortAlgorithm(int Function(dynamic, dynamic) sorter,
      {bool notify = false,}) {
    _state = _state.copyWith(sorter: sorter);
    if (notify) {
      notifyListeners();
    }
  }

  void setCurrentFilterAlgorithm(bool Function(dynamic) filter, {bool notify = false}) {
    _state = _state.copyWith(filter: filter);
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
    if (state.shownMonth.month == DateTime.now().month &&
        state.shownMonth.year == DateTime.now().year) {
      setCurrentFilterAlgorithm(
        Filters.inBetween(timestampsFromNow()),
        notify: notify,
      );
    } else {
      setCurrentFilterAlgorithm(
        Filters.inBetween(timestampsFromCurrentShownDate(state.shownMonth)),
        notify: notify,
      );
    }
  }

}
