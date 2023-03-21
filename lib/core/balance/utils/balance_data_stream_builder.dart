//  Balance Data StreamBuilder-Manager - Prepares and returns Datastreams for all kinds of lists, mostly for ListViews concerning Transactions
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (partly refactored by damattl)

// import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/widgets.dart';
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/common/types/sorter_function.dart';
import 'package:linum/common/widgets/loading_spinner.dart';
import 'package:linum/core/balance/models/algorithm_state.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/utils/date_time_extension.dart';
import 'package:linum/core/balance/utils/serial_transaction_manager.dart';
import 'package:linum/core/balance/utils/statistical_calculations.dart';
import 'package:linum/core/balance/widgets/balance_data_list_view.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/features/currencies/services/exchange_rate_service.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';

class BalanceDataStreamBuilder {
  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  static StreamBuilder fillListViewWithData({
    required BalanceDataListView listView,
    required BuildContext context,
    required Stream<firestore.DocumentSnapshot<BalanceDocument>>? dataStream,
    required AlgorithmState algorithms,
    required ExchangeRateService exchangeRateService,
    bool isSerial = false,
  }) {
    final processedStream = dataStream
        ?.asyncMap<Tuple2<List<Transaction>, List<SerialTransaction>>>(
            (snapshot) async {
      if (!isSerial) {
        final preparedData = await _prepareData(
            snapshot,
            algorithms,
            exchangeRateService,
        );
        final transactions = preparedData.item1;

        // Future there could be an sort algorithm provider
        // (and possibly also a filter algorithm provided)
        transactions.removeWhere(algorithms.filter);
        transactions.sort(algorithms.sorter);

        return Tuple2(transactions, preparedData.item2);
      } else {
        // TODO: Prepare Data once
        final data = await _prepareData(
          snapshot, algorithms, exchangeRateService,
        );
        final transactions = data.item1;
        final serialTransactions = data.item2;

        transactions.removeWhere(algorithms.filter);
        transactions.removeWhere((transaction) {
          return transaction.repeatId == null;
        });

        serialTransactions.removeWhere((serialTransaction) {
          return !transactions.any((transaction) {
            return transaction.repeatId == serialTransaction.id;
          });
        });

        serialTransactions.sort((a, b) {
          // are both expenses / incomes
          if ((a.amount <= 0 && b.amount <= 0) ||
              (a.amount > 0 && b.amount > 0)) {
            return a.name.compareTo(b.name);
          } else {
            return a.amount.compareTo(b.amount);
          }
        });

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
          Logger().e("ERROR LOADING");
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

  static Stream<StatisticalCalculations>? getStatisticCalculations({
    required Stream<firestore.DocumentSnapshot<BalanceDocument>>? dataStream,
    required AlgorithmState algorithms,
    required ExchangeRateService exchangeRateService,
  }) {
    return dataStream?.asyncMap<StatisticalCalculations>((snapshot) async {
      final preparedData = await _prepareData(
        snapshot, algorithms, exchangeRateService,
      );
      return StatisticalCalculations(
        data: preparedData.item1,
        serialData: preparedData.item2,
        standardCurrencyName: exchangeRateService.standardCurrency.name,
        algorithms: algorithms,
      );
    });
  }

  /// use the snapshot to get all data from the document.
  /// convert the List<dynamic> to a List<Map<String, dynamic>>
  /// use the repeatedbalancedata to create the missing balance data
  /// use the current _algorithmProvider filter
  /// (will still be used after filter on firebase, because of repeated balanced)
  /// may be moved into the data generation function
  static Future<Tuple2<List<Transaction>, List<SerialTransaction>>> _prepareData(
      firestore.DocumentSnapshot<BalanceDocument> snapshot,
      AlgorithmState algorithms,
      ExchangeRateService exchangeRateService,
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
      DateTime.now().returnLaterDate(
        DateTime(
          algorithms.shownMonth.year,
          algorithms.shownMonth.month + 1,
        ),
      ),
    );

    try {
      await exchangeRateService.addExchangeRatesToTransactions(transactions);
    } catch (e) {
      Logger().e(e);
    }
    return Tuple2(transactions, serialTransactions);
  }
}
