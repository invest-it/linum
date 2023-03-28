import 'package:flutter/material.dart';
import 'package:linum/common/widgets/loading_spinner.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/screens/enter_screen/actions/enter_screen_actions.dart';
import 'package:linum/screens/enter_screen/utils/supported_dates.dart';
import 'package:linum/screens/enter_screen/utils/supported_repeat_configs.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_flow.dart';
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


    initSupportedDates();
    initSupportedRepeatIntervals();

    Future<SerialTransaction?> fetchParentSerialTransaction(
        BalanceDataService balanceDataService,
        ) async {

      if (transaction?.repeatId != null) {
        return balanceDataService.findSerialTransactionWithId(transaction!.repeatId!);
      }
      return null;
    }

    return FutureBuilder<SerialTransaction?>(
      future: fetchParentSerialTransaction(
          context.read<BalanceDataService>(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData
            && snapshot.connectionState == ConnectionState.waiting
        ) {
          return const LoadingSpinner();
        }

        final balanceDataProvider = context.read<BalanceDataService>();

        return ChangeNotifierProvider(
          create: (context) {
            if (transaction != null) {
              return EnterScreenViewModel.fromTransaction(
                transaction: transaction!,
                parentalSerialTransaction: snapshot.data,
                actions: EnterScreenActions(
                  onSave: ({
                    Transaction? transaction,
                    SerialTransaction? serialTransaction,
                    SerialTransactionChangeMode? changeMode,
                  }) async {
                    if (transaction != null) {
                      balanceDataProvider.updateTransaction(transaction);
                    } else if (serialTransaction != null && changeMode != null) {
                      balanceDataProvider.updateSerialTransaction(
                        serialTransaction: serialTransaction,
                        changeMode: changeMode,
                        oldDate: this.transaction?.formerDate ?? this.transaction?.date,
                        newDate: serialTransaction.startDate,
                      );
                    }
                    Navigator.pop(context);
                  },
                  onDelete: ({
                    Transaction? transaction,
                    SerialTransaction? serialTransaction,
                    SerialTransactionChangeMode? changeMode,
                  }) {
                    if (transaction != null) {
                      balanceDataProvider.removeTransaction(transaction);
                    } else if (serialTransaction != null) {
                      // TODO
                    }
                    Navigator.pop(context);
                  },
                ),
              );
            }
            if (serialTransaction != null) {
              return EnterScreenViewModel.fromSerialTransaction(
                serialTransaction: serialTransaction!,
                actions: EnterScreenActions(
                  onSave: ({
                    Transaction? transaction,
                    SerialTransaction? serialTransaction,
                    SerialTransactionChangeMode? changeMode,
                  }) {
                    // TODO
                  },
                  onDelete: ({
                    Transaction? transaction,
                    SerialTransaction? serialTransaction,
                    SerialTransactionChangeMode? changeMode,
                  }) {

                  },
                ),
              );
            }
            return EnterScreenViewModel.empty(
              actions: EnterScreenActions(
                onSave: ({
                  Transaction? transaction,
                  SerialTransaction? serialTransaction,
                  SerialTransactionChangeMode? changeMode,
                }) {
                  if (transaction != null) {
                    balanceDataProvider.addTransaction(transaction);
                  } else if (serialTransaction != null) {
                    balanceDataProvider.addSerialTransaction(serialTransaction);
                  }
                  Navigator.pop(context);
                },
              ),
            );
          },
          child: const EnterScreenFlow(),
        );
      },
    );
  }
}
