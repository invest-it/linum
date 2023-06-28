import 'package:easy_localization/easy_localization.dart';
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
                tr("enter_screen.change-mode-selection.title"),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ChangeModeButton(
              label: tr("enter_screen.change-mode-selection.only-this-one"),
              onPressed: () => viewModel
                  .selectChangeModeType(SerialTransactionChangeMode.onlyThisOne),
            ),
            ChangeModeButton(
                label: tr("enter_screen.change-mode-selection.this-and-all-before"),
                onPressed: () => viewModel
                    .selectChangeModeType(SerialTransactionChangeMode.thisAndAllBefore),
            ),
            ChangeModeButton(
              label: tr("enter_screen.change-mode-selection.this-and-all-after"),
              onPressed: () => viewModel
                  .selectChangeModeType(SerialTransactionChangeMode.thisAndAllAfter),
            ),
            ChangeModeButton(
              label: tr("enter_screen.change-mode-selection.all"),
              onPressed: () => viewModel
                  .selectChangeModeType(SerialTransactionChangeMode.all),
            ),
          ],
        ),
      ),
    );
  }
}
