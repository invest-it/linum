import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:provider/provider.dart';

class ScreenIndexProvider extends ChangeNotifier {
  int _pageIndex = 0;

  late AlgorithmProvider _algorithmProvider;

  ScreenIndexProvider(BuildContext context) {
    _algorithmProvider = Provider.of<AlgorithmProvider>(context, listen: false);
  }

  updateAlgorithmProvider(AlgorithmProvider algo) {
    _algorithmProvider = algo;
  }

  int get pageIndex => _pageIndex;
  void setPageIndex(int index) {
    _pageIndex = index;

    if (_pageIndex == 0) {
      _algorithmProvider.resetCurrentShownMonth();
      _algorithmProvider.setCurrentFilterAlgorithm(AlgorithmProvider.inBetween(
          Timestamp.fromDate(DateTime(
            DateTime.now().year,
            DateTime.now().month,
          ).subtract(Duration(microseconds: 1))),
          Timestamp.fromDate(DateTime(
            DateTime.now().year,
            DateTime.now().month + 1,
          ))));
    }

    notifyListeners();
  }
}
