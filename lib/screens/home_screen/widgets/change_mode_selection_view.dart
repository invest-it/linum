import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/change_mode_button.dart';
import 'package:provider/provider.dart';

class SerialDeleteSelectionView extends StatelessWidget {
  final Transaction transaction;
  const SerialDeleteSelectionView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final balanceDataService = context.read<BalanceDataService>();
    final actionLip = context.read<ActionLipViewModel>();

    Future<void> callback(SerialTransactionChangeMode changeMode) async {
      final SerialTransaction? serialTransaction =  await balanceDataService.findSerialTransactionWithId(transaction.repeatId!);
      if(serialTransaction != null){
        balanceDataService.removeSerialTransaction(
          serialTransaction: serialTransaction,
          removeType: changeMode,
          date: transaction.date,
        );
      }
      if(context.mounted){
        actionLip.setActionLipStatus(
          context: context,
          screenKey: ScreenKey.home,
          status: ActionLipVisibility.hidden,
        );
      }
    }

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
        child: Container(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChangeModeButton(
                label: tr(translationKeys.enterScreen.changeModeSelection.onlyThisOne),
                onPressed: () async {

                  await callback(SerialTransactionChangeMode.onlyThisOne);
                },
              ),
              ChangeModeButton(
                  label: tr(translationKeys.enterScreen.changeModeSelection.thisAndAllBefore),
                onPressed: () async {
                  await callback(SerialTransactionChangeMode.thisAndAllBefore);
                },
              ),
              ChangeModeButton(
                label: tr(translationKeys.enterScreen.changeModeSelection.thisAndAllAfter),
                onPressed: () async {
                  await callback(SerialTransactionChangeMode.thisAndAllAfter);
                },
              ),
              ChangeModeButton(
                label: tr(translationKeys.enterScreen.changeModeSelection.all),
                onPressed: () async {
                  await callback(SerialTransactionChangeMode.all);
                },
              ),
            ],
          ),
        ),
    );



  }
}
