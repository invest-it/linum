import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/presentation/algorithm_service.dart';
import 'package:linum/core/balance/presentation/transaction_amount_formatter.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/screens/home_screen/utils/transaction_list_builder.dart';
import 'package:provider/provider.dart';

class TransactionListView extends StatelessWidget {
  final List<Transaction> transactions;
  const TransactionListView({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final algorithmService = context.watch<AlgorithmService>();
    final shownMonth = algorithmService.state.shownMonth;

    return ListView(
      padding: const EdgeInsets.only(
        bottom: 32.0,
      ),
      children: generateTransactionList(
        context: context,
        transactions: transactions,
        amountFormatter: TransactionAmountFormatter(
          context.locale,
          context.watch<ICurrencySettingsService>().getStandardCurrency(),
        ),
        shownMonth: shownMonth,
      ),
    );
  }
}
