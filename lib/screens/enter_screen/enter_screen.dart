import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_button.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_text_field.dart';
import 'package:linum/screens/enter_screen/widgets/quick_tag_menu.dart';
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


    return Container(
      height: 250 + useKeyBoardHeight(context),
      padding: EdgeInsets.only(
        top: 25,
        bottom: 25 + useKeyBoardHeight(context),
      ),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ChangeNotifierProvider(
            create: (context) {
              if (transaction != null) {
                return EnterScreenViewModel.fromTransaction(
                  context,
                  transaction: transaction!,
                  onSave: ({
                      Transaction? transaction,
                      SerialTransaction? serialTransaction,
                  }) {
                      if (transaction != null) {
                        balanceDataProvider.updateTransaction(transaction);
                      } else if (serialTransaction != null) {
                        // TODO
                      }
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
                  },
              );
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: const EnterScreenTextField(),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(
                        child: QuickTagMenu(),
                      ),
                      EnterScreenButton()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
