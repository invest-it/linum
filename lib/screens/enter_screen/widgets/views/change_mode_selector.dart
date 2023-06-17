import 'package:flutter/material.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/change_mode_button.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_scaffold.dart';
import 'package:provider/provider.dart';

class ChangeModeSelector extends StatelessWidget {
  const ChangeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EnterScreenViewModel>();


    return EnterScreenScaffold(
      bodyHeight: 300,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Text(
                "Wiederkehrende Einträge ändern",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ChangeModeButton(
              label: "Only this one",
              onPressed: () => viewModel
                  .selectChangeModeType(SerialTransactionChangeMode.onlyThisOne),
            ),
            ChangeModeButton(
                label: "All before",
                onPressed: () => viewModel
                    .selectChangeModeType(SerialTransactionChangeMode.thisAndAllBefore),
            ),
            ChangeModeButton(
              label: "All afterwards",
              onPressed: () => viewModel
                  .selectChangeModeType(SerialTransactionChangeMode.thisAndAllAfter),
            ),
            ChangeModeButton(
              label: "All",
              onPressed: () => viewModel
                  .selectChangeModeType(SerialTransactionChangeMode.all),
            ),
          ],
        ),
      ),
    );
  }
}
