//  Screen Index Provider - Essential Provider that determines the current viewport state of the app
//  NOTE: THIS PROVIDER IS GOING TO BE REPLACED SOON.
//  Author: SoTBurst
//  Co-Author: NightmindOfficial, thebluebaronx
//  (Partly refactored by damattl)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/utilities/frontend/filter_functions.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ScreenIndexProvider extends ChangeNotifier {
  int _pageIndex = 0;

  late AlgorithmProvider _algorithmProvider;

  ScreenIndexProvider(BuildContext context) {
    _algorithmProvider = Provider.of<AlgorithmProvider>(context, listen: false);
  }

  void updateAlgorithmProvider(AlgorithmProvider algo) {
    _algorithmProvider = algo;
  }

  int get pageIndex => _pageIndex;
  void setPageIndex(int index) {
    setPageIndexSilently(index);
    notifyListeners();
  }

  void setPageIndexSilently(int index) {
    _pageIndex = index;

    if (_pageIndex == 0) {
      _algorithmProvider.resetCurrentShownMonth();
      _algorithmProvider.setCurrentFilterAlgorithm(
        inBetween(
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
    }
  }

  static SingleChildWidget provider(BuildContext context, {bool testing = false}) {
    return ChangeNotifierProxyProvider<AlgorithmProvider,
        ScreenIndexProvider>(
      create: (ctx) => ScreenIndexProvider(ctx),
      update: (ctx, algo, oldScreenIndexProvider) {
        if (oldScreenIndexProvider == null) {
          return ScreenIndexProvider(ctx);
        } else {
          return oldScreenIndexProvider
            ..updateAlgorithmProvider(algo);
        }
      },
    );
  }
}
