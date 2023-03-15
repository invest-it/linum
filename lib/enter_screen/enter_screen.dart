import 'package:flutter/material.dart';
import 'package:linum/enter_screen/view_models/enter_screen_view_model.dart';
import 'package:linum/enter_screen/widgets/enter_screen_button.dart';
import 'package:linum/enter_screen/widgets/enter_screen_text_field.dart';
import 'package:linum/enter_screen/widgets/quick_tag_menu.dart';
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/models/transaction.dart';
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
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ChangeNotifierProvider(
            create: (context) {
              if (transaction != null) {
                return EnterScreenViewModel.fromTransaction(context, transaction!);
              }
              if (serialTransaction != null) {
                return EnterScreenViewModel.fromSerialTransaction(context, serialTransaction!);
              }
              return EnterScreenViewModel.empty(context);
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

// TODO: Implement saving functionality
