//  Balance Data StreamBuilder-Manager - Prepares and returns Datastreams for all kinds of lists, mostly for ListViews concerning Transactions
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (partly refactored by damattl)

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/widgets.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/models/transaction.dart';
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
    required Stream<firestore.DocumentSnapshot<BalanceDocument>>? dataStream,
    bool isRepeatable = false,
  }) {
    return StreamBuilder<firestore.DocumentSnapshot<BalanceDocument>>(
      stream: dataStream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingSpinner();
        }
        if (snapshot.data == null) {
          // TODO tell the user that the connection is broken
          listView.setSingleBalanceData(
            [],
            context: context,
          );
          log("ERROR LOADING");
          return listView.listview;
        } else {
          if (!isRepeatable) {
            final preparedData = _prepareData(
              snapshot,
            );
            final balanceData = preparedData.item1;

            // Future there could be an sort algorithm provider
            // (and possibly also a filter algorithm provided)
            balanceData.removeWhere(algorithmProvider.currentFilter);
            balanceData.sort(algorithmProvider.currentSorter);

            listView.setSingleBalanceData(
              balanceData,
              context: context,
            );
          } else {
            final data = _prepareData(
              snapshot,
            );
            final singleBalanceData = data.item1;
            final repeatedBalanceData = data.item2;

            singleBalanceData.removeWhere(algorithmProvider.currentFilter);
            singleBalanceData.removeWhere((transaction) {
              return transaction.repeatId == null;
            });

            repeatedBalanceData.removeWhere((serialTransaction) {
              return !singleBalanceData.any((transaction) {
                return transaction.repeatId == serialTransaction.id;
              });
            });

            listView.setRepeatedBalanceData(
              repeatedBalanceData,
              context: context,
            );
          }
          return listView.listview;
        }
      },
    );
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  static StreamBuilder fillStatisticPanelWithData({
    required AlgorithmProvider algorithmProvider,
    required Stream<firestore.DocumentSnapshot<BalanceDocument>>? dataStream,
    required AbstractHomeScreenCard statisticPanel,
  }) {
    return StreamBuilder<firestore.DocumentSnapshot<BalanceDocument>>(
      stream: dataStream,
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          statisticPanel.addStatisticData(null);
          return statisticPanel.returnWidget;
        } else {
          final preparedData = _prepareData(
            snapshot,
          );
          final List<Transaction> balanceData = preparedData.item1;
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
  static Tuple2<List<Transaction>, List<SerialTransaction>> _prepareData(
    AsyncSnapshot<firestore.DocumentSnapshot<BalanceDocument>> snapshot,
  ) {
    final data = snapshot.data?.data(); // TODO: Model for Document

    if (data == null) {
      return const Tuple2(<Transaction>[], <SerialTransaction>[]);
    }

    final List<Transaction> balanceData = <Transaction>[];

    for (final singleBalance in data.transactions) {
      if (singleBalance.repeatId == null) {
        balanceData.add(singleBalance);
      }
    }

    final List<SerialTransaction> repeatedBalance = <SerialTransaction>[];

    for (final singleRepeatable in data.serialTransactions) {
      repeatedBalance.add(singleRepeatable);
    }

    RepeatedBalanceDataManager.addAllRepeatablesToBalanceDataLocally(
      repeatedBalance,
      balanceData,
    );

    return Tuple2(balanceData, repeatedBalance);
  }
}
