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
import 'package:linum/features/currencies/core/presentation/exchange_rate_service.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';

typedef PreparedBalanceData = Tuple2<List<Transaction>, List<SerialTransaction>>;


Future<Tuple2<List<Transaction>, List<SerialTransaction>>>
  processBalanceData({
  required DocumentSnapshot<BalanceDocument> snapshot,
  required AlgorithmState algorithms,
  required IExchangeRateService exchangeRateService,
  bool isSerial = false,
}) async {
  if (!isSerial) {
    return _processTransactions(
        snapshot: snapshot,
        algorithms: algorithms,
        exchangeRateService: exchangeRateService,
    );
  } else {
    // TODO: Prepare Data once
    return _processSerialTransactions(
        snapshot: snapshot,
        algorithms: algorithms,
        exchangeRateService: exchangeRateService,
    );
  }
}

Future<Tuple2<List<Transaction>, List<SerialTransaction>>>
_processTransactions({
  required DocumentSnapshot<BalanceDocument> snapshot,
  required AlgorithmState algorithms,
  required IExchangeRateService exchangeRateService,
}) async {
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
}


Future<Tuple2<List<Transaction>, List<SerialTransaction>>>
_processSerialTransactions({
  required DocumentSnapshot<BalanceDocument> snapshot,
  required AlgorithmState algorithms,
  required IExchangeRateService exchangeRateService,
}) async {
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



Future<StatisticalCalculations> generateStatistics({
  required  DocumentSnapshot<BalanceDocument> snapshot,
  required AlgorithmState algorithms,
  required IExchangeRateService exchangeRateService,
}) async {
  final preparedData = await _prepareData(
    snapshot, algorithms, exchangeRateService,
  );
  return StatisticalCalculations(
    data: preparedData.item1,
    serialData: preparedData.item2,
    standardCurrencyName: exchangeRateService.standardCurrency.name,
    algorithms: algorithms,
  );

}


Future<PreparedBalanceData> _prepareData(
    DocumentSnapshot<BalanceDocument> snapshot,
    AlgorithmState algorithms,
    IExchangeRateService exchangeRateService,
) async {

  final data = snapshot.data(); // TODO: Model for Document
  if (data == null) {
    return const Tuple2(<Transaction>[], <SerialTransaction>[]);
  }

  final transactions = <Transaction>[];
  for (final transaction in data.transactions) {
    if (transaction.repeatId == null) {
      transactions.add(transaction);
    }
  }

  final serialTransactions = <SerialTransaction>[];
  for (final singleRepeatable in data.serialTransactions) {
    serialTransactions.add(singleRepeatable);
  }


  final nextMonth = DateTime(
    algorithms.shownMonth.year,
    algorithms.shownMonth.month + 1,
  );
  SerialTransactionManager.addAllSerialTransactionsToTransactionsLocally(
    serialTransactions,
    transactions,
    DateTime.now().returnLaterDate(nextMonth),
  );

  try {
    await exchangeRateService.addExchangeRatesToTransactions(transactions);
  } catch (e) {
    Logger().e(e);
  }

  return Tuple2(transactions, serialTransactions);
}
