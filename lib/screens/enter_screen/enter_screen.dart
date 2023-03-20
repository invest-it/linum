import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/screens/enter_screen/utils/supported_dates.dart';
import 'package:linum/screens/enter_screen/utils/supported_repeat_configs.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_layout.dart';
import 'package:provider/provider.dart';

class EnterScreen extends StatelessWidget {
  final Transaction? transaction;
  final SerialTransaction? serialTransaction;
  const EnterScreen({
    super.key,
    this.transaction,
    this.serialTransaction,
  });


  @override
  Widget build(BuildContext context) {
    final balanceDataProvider = Provider.of<BalanceDataService>(context, listen: false);

    initSupportedDates();
    initSupportedRepeatIntervals();

    return ChangeNotifierProvider(
      create: (context) {
        if (transaction != null) {
          return EnterScreenViewModel.fromTransaction(
            context,
            transaction: transaction!,
            onSave: ({
              Transaction? transaction,
              SerialTransaction? serialTransaction,
            }) async {
              if (transaction != null) {
                balanceDataProvider.updateTransaction(transaction);
              } else if (serialTransaction != null) {
                // TODO
              }
              Navigator.pop(context);
            },
            onDelete: ({
              Transaction? transaction,
              SerialTransaction? serialTransaction,
            }) {
              if (transaction != null) {
                balanceDataProvider.removeTransaction(transaction);
              } else if (serialTransaction != null) {
                // TODO
              }
              Navigator.pop(context);
            },
          );
        }
        if (serialTransaction != null) {
          return EnterScreenViewModel.fromSerialTransaction(
            context,
            serialTransaction: serialTransaction!,
            onSave: ({
              Transaction? transaction,
              SerialTransaction? serialTransaction,
            }) {
                // TODO
            },
            onDelete: ({
              Transaction? transaction,
              SerialTransaction? serialTransaction,
            }) {

            },
          );
        }
        return EnterScreenViewModel.empty(
          context,
          onSave: ({
            Transaction? transaction,
            SerialTransaction? serialTransaction,
          }) {
            if (transaction != null) {
              balanceDataProvider.addTransaction(transaction);
            } else if (serialTransaction != null) {
              balanceDataProvider.addSerialTransaction(serialTransaction);
            }
            Navigator.pop(context);
          },

        );
      },
      child: const EnterScreenLayout(),
    );
  }
}
