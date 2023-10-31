import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/show_transaction_delete_dialog.dart';
import 'package:linum/common/widgets/loading_spinner.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/screens/enter_screen/presentation/actions/enter_screen_actions.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/enter_screen_flow.dart';
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
    Future<SerialTransaction?> fetchParentSerialTransaction(
      BalanceDataService balanceDataService,
    ) async {
      if (transaction?.repeatId != null) {
        return balanceDataService
            .findSerialTransactionWithId(transaction!.repeatId!);
      }
      return null;
    }

    return FutureBuilder<SerialTransaction?>(
      future: fetchParentSerialTransaction(
        context.read<BalanceDataService>(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingSpinner();
        }
        return ChangeNotifierProvider(
          create: (context) {
            return _createViewModel(context, snapshot);
          },
          child: const EnterScreenFlow(),
        );
      },
    );
  }

  EnterScreenViewModel _createViewModel(
    BuildContext context,
    AsyncSnapshot<SerialTransaction?> snapshot,
  ) {
    if (transaction != null) {
      return EnterScreenViewModel.fromTransaction(
        transaction: transaction!,
        parentalSerialTransaction: snapshot.data,
        actions: _setupTransactionActions(context),
      );
    }
    if (serialTransaction != null) {
      return EnterScreenViewModel.fromSerialTransaction(
        serialTransaction: serialTransaction!,
        actions: _setupSerialTransactionActions(context),
      );
    }
    return EnterScreenViewModel.empty(
      actions: _setupEmptyActions(context),
    );
  }

  EnterScreenActions _setupEmptyActions(BuildContext context) {
    final balanceDataService = context.read<BalanceDataService>();

    return EnterScreenActions(
      onSave: ({
        Transaction? transaction,
        SerialTransaction? serialTransaction,
        SerialTransactionChangeMode? changeMode,
      }) {
        if (transaction != null) {
          balanceDataService.addTransaction(transaction);
        } else if (serialTransaction != null) {
          balanceDataService.addSerialTransaction(serialTransaction);
        }
        Navigator.pop(context);
      },
    );
  }

  EnterScreenActions _setupTransactionActions(BuildContext context) {
    final balanceDataService = context.read<BalanceDataService>();

    return EnterScreenActions(
      onSave: ({
        Transaction? transaction,
        SerialTransaction? serialTransaction,
        SerialTransactionChangeMode? changeMode,
      }) async {
        if (transaction != null) {
          balanceDataService.updateTransaction(transaction);
        } else if (serialTransaction != null && changeMode != null) {
          balanceDataService.updateSerialTransaction(
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
        showTransactionDeleteDialog(context, () {
          if (transaction != null && changeMode == null) {
            balanceDataService.removeTransaction(transaction);
          } else if (serialTransaction != null && changeMode != null) {
            balanceDataService.removeSerialTransaction(
              serialTransaction: serialTransaction,
              removeType: changeMode,
              date: transaction?.date,
            );
          }
          Navigator.pop(context);
        });
      },
    );
  }

  EnterScreenActions _setupSerialTransactionActions(BuildContext context) {
    final balanceDataService = context.read<BalanceDataService>();

    return EnterScreenActions(
      onSave: ({
        Transaction? transaction,
        SerialTransaction? serialTransaction,
        SerialTransactionChangeMode? changeMode,
      }) {
        if (transaction != null) {
          balanceDataService.updateTransaction(transaction);
        } else if (serialTransaction != null && changeMode != null) {
          balanceDataService.updateSerialTransaction(
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
        showTransactionDeleteDialog(context, () {
          if (transaction != null && changeMode == null) {
            balanceDataService.removeTransaction(transaction);
          } else if (serialTransaction != null && changeMode != null) {
            balanceDataService.removeSerialTransaction(
              serialTransaction: serialTransaction,
              removeType: changeMode,
              date: transaction?.date,
            );
          }
        });
      },
    );
  }
}
