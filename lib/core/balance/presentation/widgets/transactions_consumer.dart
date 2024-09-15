import 'package:flutter/material.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/presentation/algorithm_service.dart';
import 'package:linum/core/balance/presentation/balance_data_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class TransactionsConsumer extends SingleChildStatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<List<Transaction>>, Widget?) builder;

  const TransactionsConsumer({
    super.key,
    required this.builder,
  });

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer2<IBalanceDataService, AlgorithmService>(
      builder: (context, balanceDataService, algorithmService, child) {
        final transactions = balanceDataService.getTransactionsForMonth(algorithmService.state.shownMonth);
        final future = transactions.then((t) {
          return t
            ..removeWhere(algorithmService.state.filter)
            ..sort(algorithmService.state.sorter);
        });

        return FutureBuilder<List<Transaction>>(
          future: future,
          builder: (context, snapshot) => builder(context, snapshot, child),
        );
      },
      child: child,
    );
  }
}

class SerialTransactionsConsumer extends SingleChildStatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<List<SerialTransaction>>, Widget?) builder;

  const SerialTransactionsConsumer({
    super.key,
    required this.builder,
  });

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer2<IBalanceDataService, AlgorithmService>(
      builder: (context, balanceDataService, algorithmService, child) {
        final serialTransactions = balanceDataService.getSerialTransactionsForMonth(algorithmService.state.shownMonth);

        final future = serialTransactions.then((s) {
          return s..sort((a, b) {
            // are both expenses / incomes
            if ((a.amount <= 0 && b.amount <= 0) ||
                (a.amount > 0 && b.amount > 0)) {
              return a.name.compareTo(b.name);
            } else {
              return a.amount.compareTo(b.amount);
            }
          });
        });


        return FutureBuilder<List<SerialTransaction>>(
          future: future,
          builder: (context, snapshot) => builder(context, snapshot, child),
        );
      },
      child: child,
    );
  }
}
