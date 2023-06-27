//  Balance Data StreamBuilder-Manager - Prepares and returns Datastreams for all kinds of lists, mostly for ListViews concerning Transactions
//
//  Author: SoTBurst
//  Co-Author: n/a
//  (partly refactored by damattl)

// import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:linum/core/balance/models/algorithm_state.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/utils/date_time_extension.dart';
import 'package:linum/core/balance/utils/serial_transaction_manager.dart';
import 'package:linum/core/balance/utils/statistical_calculations.dart';
import 'package:linum/features/currencies/services/exchange_rate_service.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';

typedef PreparedBalanceData = Tuple2<List<Transaction>, List<SerialTransaction>>;

Future<PreparedBalanceData> prepareData(
     DocumentSnapshot<BalanceDocument> snapshot,
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

Future<Tuple2<List<Transaction>, List<SerialTransaction>>>
  processBalanceData({
  required DocumentSnapshot<BalanceDocument> snapshot,
  required AlgorithmState algorithms,
  required ExchangeRateService exchangeRateService,
  bool isSerial = false,
}) async {
  if (!isSerial) {
    final preparedData = await prepareData(
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
    final data = await prepareData(
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
}

Future<StatisticalCalculations> generateStatistics({
  required  DocumentSnapshot<BalanceDocument> snapshot,
  required AlgorithmState algorithms,
  required ExchangeRateService exchangeRateService,
}) async {
  final preparedData = await prepareData(
    snapshot, algorithms, exchangeRateService,
  );
  return StatisticalCalculations(
    data: preparedData.item1,
    serialData: preparedData.item2,
    standardCurrencyName: exchangeRateService.standardCurrency.name,
    algorithms: algorithms,
  );

}