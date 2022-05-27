//  Balance Data StreamBuilder-Manager - Prepares and returns Datastreams for all kinds of lists, mostly for ListViews concerning Transactions
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (partly refactored by damattl)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/utilities/backend/statistic_calculations.dart';
import 'package:linum/utilities/balance_data/repeated_balance_data_manager.dart';
import 'package:linum/widgets/abstract/abstract_home_screen_card.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:linum/widgets/loading_spinner.dart';

class BalanceDataStreamBuilderManager {
  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillListViewWithData({
    required AlgorithmProvider algorithmProvider,
    required BalanceDataListView blistview,
    required BuildContext context,
    required Stream<DocumentSnapshot<Map<String, dynamic>>>? dataStream,
    required RepeatedBalanceDataManager repeatedBalanceDataManager,
  }) {
    return StreamBuilder(
      stream: dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return const LoadingSpinner();
        }
        if (snapshot.data == null) {
          blistview.setBalanceData(
            [
              {"Error": "snapshot.data == null"}
            ],
            context: context,
          );
          return blistview.listview;
        } else {
          final List<List<Map<String, dynamic>>> arrayData = prepareData(
            repeatedBalanceDataManager,
            snapshot,
          );
          final List<Map<String, dynamic>> balanceData = arrayData[0];

          // Future there could be an sort algorithm provider
          // (and possibly also a filter algorithm provided)
          balanceData.removeWhere(algorithmProvider.currentFilter);
          balanceData.sort(algorithmProvider.currentSorter);
          blistview.setBalanceData(balanceData, context: context);
          return blistview.listview;
        }
      },
    );
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillStatisticPanelWithData({
    required AlgorithmProvider algorithmProvider,
    required Stream<DocumentSnapshot<Map<String, dynamic>>>? dataStream,
    required RepeatedBalanceDataManager repeatedBalanceDataManager,
    required AbstractHomeScreenCard statisticPanel,
  }) {
    return StreamBuilder(
      stream: dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          statisticPanel.addStatisticData(null);
          return statisticPanel.returnWidget;
        } else {
          final List<List<Map<String, dynamic>>> arrayData = prepareData(
            repeatedBalanceDataManager,
            snapshot,
          );
          final List<Map<String, dynamic>> balanceData = arrayData[0];
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(balanceData, algorithmProvider);
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
  List<List<Map<String, dynamic>>> prepareData(
    RepeatedBalanceDataManager repeatedBalanceDataManager,
    AsyncSnapshot<dynamic> snapshot,
  ) {
    final Map<String, dynamic>? data =
        (snapshot.data as DocumentSnapshot<Map<String, dynamic>>).data();
    final List<dynamic> balanceDataDynamic =
        data!["balanceData"] as List<dynamic>;
    final List<Map<String, dynamic>> balanceData = <Map<String, dynamic>>[];
    for (final singleBalance in balanceDataDynamic) {
      if ((singleBalance as Map<String, dynamic>)["repeatId"] == null) {
        balanceData.add(singleBalance);
      }
    }

    final List<dynamic> repeatedBalanceDynamic =
        data["repeatedBalance"] as List<dynamic>;
    final List<Map<String, dynamic>> repeatedBalance = <Map<String, dynamic>>[];
    for (final singleRepeatable in repeatedBalanceDynamic) {
      repeatedBalance.add(singleRepeatable as Map<String, dynamic>);
    }

    repeatedBalanceDataManager.addAllRepeatablesToBalanceDataLocally(
      repeatedBalance,
      balanceData,
    );

    return [balanceData, repeatedBalance];
  }
}
