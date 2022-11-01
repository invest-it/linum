//  Balance Data StreamBuilder-Manager - Prepares and returns Datastreams for all kinds of lists, mostly for ListViews concerning Transactions
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (partly refactored by damattl)

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/exchange_rate_provider.dart';
import 'package:linum/utilities/backend/statistic_calculations.dart';
import 'package:linum/utilities/balance_data/repeated_balance_data_manager.dart';
import 'package:linum/widgets/abstract/abstract_home_screen_card.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:linum/widgets/loading_spinner.dart';
import 'package:tuple/tuple.dart';

class BalanceDataStreamBuilderManager {
  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  static StreamBuilder fillListViewWithData({
    required AlgorithmProvider algorithmProvider,
    required ExchangeRateProvider exchangeRateProvider,
    required BalanceDataListView listView,
    required BuildContext context,
    required Stream<DocumentSnapshot<BalanceDocument>>? dataStream,
  }) {
    return StreamBuilder<DocumentSnapshot<BalanceDocument>>(
      stream: dataStream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingSpinner();
        }
        if (snapshot.data == null) {
          // TODO tell the user that the connection is broken
          blistview.setSingleBalanceData(
            [],
            context: context,
          );
          log("ERROR LOADING");
          return listView.listview;
        } else {
          if (!repeatables) {
            final List<List<Map<String, dynamic>>> arrayData = prepareData(
              repeatedBalanceDataManager,
              snapshot,
            );
            final List<Map<String, dynamic>> balanceData = arrayData[0];

            // Future there could be an sort algorithm provider
            // (and possibly also a filter algorithm provided)
            balanceData.removeWhere(algorithmProvider.currentFilter);
            balanceData.sort(algorithmProvider.currentSorter);

            blistview.setSingleBalanceData(
              listOfSingleMapsToListOfModels(balanceData),
              context: context,
            );
          } else {
            final List<List<Map<String, dynamic>>> arrayData = prepareData(
              repeatedBalanceDataManager,
              snapshot,
            );
            final List<Map<String, dynamic>> singleBalanceDataMap =
                arrayData[0];
            final List<Map<String, dynamic>> repeatedBalanceDataMap =
                arrayData[1];
            List<SingleBalanceData> singleBalanceData =
                listOfSingleMapsToListOfModels(singleBalanceDataMap);

            List<RepeatedBalanceData> repeatedBalanceData =
                listOfRepeatedMapsToListOfModels(repeatedBalanceDataMap);

            singleBalanceData.removeWhere(algorithmProvider.currentFilter);
            singleBalanceData.removeWhere((sin) {
              return sin.repeatId == null;
            });

            repeatedBalanceData.removeWhere((rep) {
              return !singleBalanceData.any((sin) {
                return sin.repeatId == rep.id;
              });
            });

            blistview.setRepeatedBalanceData(
              repeatedBalanceData,
              context: context,
            );
          }
          return blistview.listview;
        }
      },
    );
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  static StreamBuilder fillStatisticPanelWithData({
    required AlgorithmProvider algorithmProvider,
    required Stream<DocumentSnapshot<BalanceDocument>>? dataStream,
    required AbstractHomeScreenCard statisticPanel,
  }) {
    return StreamBuilder<DocumentSnapshot<BalanceDocument>>(
      stream: dataStream,
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          statisticPanel.addStatisticData(null);
          return statisticPanel.returnWidget;
        } else {
          final Tuple2<List<SingleBalanceData>, List<RepeatedBalanceData>> preparedData = _prepareData(
            snapshot,
          );
          final List<SingleBalanceData> balanceData = preparedData.item1;
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
                balanceData,
                algorithmProvider,
              );
          statisticPanel.addStatisticData(statisticsCalculations);
          return statisticPanel.returnWidget;
        }
      },
    );
  }

  /// use the snapshot to get all data from the document.
  /// convert the List<dynamic> to a List<Map<String, dynamic>>
  /// use the repeatedbalancedata to create the missing balance data
  /// use the current _algorithmProvider filter
  /// (will still be used after filter on firebase, because of repeated balanced)
  /// may be moved into the data generation function
  static Tuple2<List<SingleBalanceData>, List<RepeatedBalanceData>> _prepareData(
    AsyncSnapshot<DocumentSnapshot<BalanceDocument>> snapshot,
  ) {
    final data = snapshot.data?.data(); // TODO: Model for Document

    if (data == null) {
      return const Tuple2(<SingleBalanceData>[], <RepeatedBalanceData>[]);
    }

    final List<SingleBalanceData> balanceData = <SingleBalanceData>[];

    for (final singleBalance in data.balanceData) {
      if (singleBalance.repeatId == null) {
        balanceData.add(singleBalance);
      }
    }

    final List<RepeatedBalanceData> repeatedBalance = <RepeatedBalanceData>[];

    for (final singleRepeatable in data.repeatedBalance) {
      repeatedBalance.add(singleRepeatable);
    }

    RepeatedBalanceDataManager.addAllRepeatablesToBalanceDataLocally(
      repeatedBalance,
      balanceData,
    );

    return Tuple2(balanceData, repeatedBalance);
  }
}

List<SingleBalanceData> listOfSingleMapsToListOfModels(
  List<Map<String, dynamic>> balanceData,
) {
  final List<SingleBalanceData> listOfModels = [];
  for (final mapEntry in balanceData) {
    listOfModels.add(SingleBalanceData.fromMap(mapEntry));
  }

  return listOfModels;
}

List<RepeatedBalanceData> listOfRepeatedMapsToListOfModels(
  List<Map<String, dynamic>> balanceData,
) {
  final List<RepeatedBalanceData> listOfModels = [];
  for (final mapEntry in balanceData) {
    listOfModels.add(RepeatedBalanceData.fromMap(mapEntry));
  }

  return listOfModels;
}
