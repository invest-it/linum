import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/enter_screen/presentation/enums/edit_intention.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/change_mode_button.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/enter_screen_scaffold.dart';
import 'package:provider/provider.dart';

class ChangeModeSelectionView extends StatelessWidget {
  const ChangeModeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EnterScreenViewModel>();

    final title = viewModel.intention == EditIntention.delete
        ? tr(translationKeys.enterScreen.changeModeSelection.title.delete)
        : tr(translationKeys.enterScreen.changeModeSelection.title.save);

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
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ChangeModeButton(
              label: tr(translationKeys.enterScreen.changeModeSelection.onlyThisOne),
              onPressed: () => viewModel
                  .selectChangeModeType(SerialTransactionChangeMode.onlyThisOne),
            ),
            ChangeModeButton(
                label: tr(translationKeys.enterScreen.changeModeSelection.thisAndAllBefore),
                onPressed: () => viewModel
                    .selectChangeModeType(SerialTransactionChangeMode.thisAndAllBefore),
            ),
            ChangeModeButton(
              label: tr(translationKeys.enterScreen.changeModeSelection.thisAndAllAfter),
              onPressed: () => viewModel
                  .selectChangeModeType(SerialTransactionChangeMode.thisAndAllAfter),
            ),
            ChangeModeButton(
              label: tr(translationKeys.enterScreen.changeModeSelection.all),
              onPressed: () => viewModel
                  .selectChangeModeType(SerialTransactionChangeMode.all),
            ),
          ],
        ),
      ),
    );
  }
}
