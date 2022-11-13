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
import 'package:linum/utilities/backend/statistical_calculations.dart';
import 'package:linum/utilities/balance_data/serial_transaction_manager.dart';
import 'package:linum/widgets/abstract/abstract_home_screen_card.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:linum/widgets/loading_spinner.dart';
import 'package:tuple/tuple.dart';

class BalanceDataStreamBuilder {
  final AlgorithmProvider algorithmProvider;
  final ExchangeRateProvider exchangeRateProvider;

  BalanceDataStreamBuilder(this.algorithmProvider, this.exchangeRateProvider);

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillListViewWithData({
    required BalanceDataListView listView,
    required BuildContext context,
    required Stream<firestore.DocumentSnapshot<BalanceDocument>>? dataStream,
    bool isSerial = false,
  }) {
    final processedStream = dataStream?.asyncMap<Tuple2<List<Transaction>, List<SerialTransaction>>>((snapshot) async {
      if (!isSerial) {
        final preparedData = await _prepareData(snapshot);
        final transactions = preparedData.item1;

        // Future there could be an sort algorithm provider
        // (and possibly also a filter algorithm provided)
        transactions.removeWhere(algorithmProvider.currentFilter);
        transactions.sort(algorithmProvider.currentSorter);

        return Tuple2(transactions, preparedData.item2);
      } else {
        // TODO: Prepare Data once
        final data = await _prepareData(
          snapshot,
        );
        final transactions = data.item1;
        final serialTransactions = data.item2;

        transactions.removeWhere(algorithmProvider.currentFilter);
        transactions.removeWhere((transaction) {
          return transaction.repeatId == null;
        });

        serialTransactions.removeWhere((serialTransaction) {
          return !transactions.any((transaction) {
            return transaction.repeatId == serialTransaction.id;
          });
        });

        serialTransactions.sort((a, b) => a.name.compareTo(b.name));

        return Tuple2(data.item1, serialTransactions);
      }
    });

    return StreamBuilder<Tuple2<List<Transaction>, List<SerialTransaction>>>(
      stream: processedStream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingSpinner();
        }
        if (snapshot.data == null) {
          // TODO tell the user that the connection is broken
          listView.setTransactions(
            [],
            context: context,
          );
          log("ERROR LOADING");
          return listView.listview;
        } else {
          if (!isSerial) {
            listView.setTransactions(
              snapshot.data!.item1,
              context: context,
            );
          } else {
            listView.setSerialTransactions(
              snapshot.data!.item2,
              context: context,
            );
          }
          return listView.listview;
        }
      },
    );
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillStatisticPanelWithData({
    required Stream<firestore.DocumentSnapshot<BalanceDocument>>? dataStream,
    required AbstractHomeScreenCard statisticPanel,
  }) {
    final processedStream = dataStream?.asyncMap<StatisticalCalculations>((snapshot) async {
      final preparedData = await _prepareData(
        snapshot,
      );
      final List<Transaction> transactions = preparedData.item1;

      return StatisticalCalculations(
        transactions,
        exchangeRateProvider.standardCurrency.name,
        algorithmProvider,
      );

    });

    return StreamBuilder<StatisticalCalculations>(
      stream: processedStream,
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          statisticPanel.addStatisticData(null);
          return statisticPanel.returnWidget;
        } else {
          statisticPanel.addStatisticData(snapshot.data);
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
  Future<Tuple2<List<Transaction>, List<SerialTransaction>>> _prepareData(
    firestore.DocumentSnapshot<BalanceDocument> snapshot,
  ) async {
    final data = snapshot.data(); // TODO: Model for Document

    if (data == null) {
      return const Tuple2(<Transaction>[], <SerialTransaction>[]);
    }

    final List<Transaction> transactions = <Transaction>[];

    for (final transaction in data.transactions) {
      if (transaction.repeatId == null) {
        transactions.add(transaction);
      }
    }

    final List<SerialTransaction> serialTransactions = <SerialTransaction>[];

    for (final singleRepeatable in data.serialTransactions) {
      serialTransactions.add(singleRepeatable);
    }

    SerialTransactionManager.addAllSerialTransactionsToTransactionsLocally(
      serialTransactions,
      transactions,
    );

    try {
      await exchangeRateProvider.addExchangeRatesToTransactions(transactions);
    } catch(e) {
      print("RatesError");
      print(e);
    }
    return Tuple2(transactions, serialTransactions);
  }
}
