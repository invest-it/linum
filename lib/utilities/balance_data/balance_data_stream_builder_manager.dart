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
    required BalanceDataListView listView,
    required BuildContext context,
    required Stream<DocumentSnapshot<BalanceDocument>>? dataStream,
  }) {
    return StreamBuilder(
      stream: dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return const LoadingSpinner();
        }
        if (snapshot.data == null) {
          // TODO tell the user that the connection is broken
          listView.setBalanceData(
            [],
            context: context,
          );
          log("ERROR LOADING");
          return listView.listview;
        } else {
          final Tuple2<List<SingleBalanceData>, List<RepeatedBalanceData>> preparedData = _prepareData(
            snapshot,
          );
          final List<SingleBalanceData> balanceData = preparedData.item1;

          // Future there could be an sort algorithm provider
          // (and possibly also a filter algorithm provided)
          balanceData.removeWhere(algorithmProvider.currentFilter);
          balanceData.sort(algorithmProvider.currentSorter);

          listView.setBalanceData(
            balanceData,
            context: context,
          );
          return listView.listview;
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
    return StreamBuilder(
      stream: dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
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
    AsyncSnapshot<dynamic> snapshot,
  ) {
    final Map<String, dynamic>? data = (snapshot.data as DocumentSnapshot<Map<String, dynamic>>).data(); // TODO: Model for Document

    final List<dynamic> balanceDataDynamic = data!["balanceData"] as List<dynamic>;

    final List<SingleBalanceData> balanceData = <SingleBalanceData>[];

    for (final singleBalanceMap in balanceDataDynamic) {
      final singleBalance = SingleBalanceData.fromMap(singleBalanceMap as Map<String, dynamic>);
      if (singleBalance.repeatId == null) {
        balanceData.add(singleBalance);
      }
    }

    final List<dynamic> repeatedBalanceDynamic = data["repeatedBalance"] as List<dynamic>;

    final List<RepeatedBalanceData> repeatedBalance = <RepeatedBalanceData>[];

    for (final singleRepeatable in repeatedBalanceDynamic) {
      repeatedBalance.add(singleRepeatable as RepeatedBalanceData);
    }

    RepeatedBalanceDataManager.addAllRepeatablesToBalanceDataLocally(
      repeatedBalance,
      balanceData,
    );

    return Tuple2(balanceData, repeatedBalance);
  }
}

List<SingleBalanceData> listOfMapsToListOfModels(
  List<Map<String, dynamic>> balanceData,
) {
  final List<SingleBalanceData> listOfModels = [];
  for (final mapEntry in balanceData) {
    listOfModels.add(SingleBalanceData.fromMap(mapEntry));
  }

  return listOfModels;
}
