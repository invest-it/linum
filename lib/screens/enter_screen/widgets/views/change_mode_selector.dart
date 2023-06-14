import 'package:flutter/material.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_scaffold.dart';
import 'package:provider/provider.dart';

class ChangeModeSelector extends StatelessWidget {
  const ChangeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EnterScreenViewModel>();
    return EnterScreenScaffold(
      bodyHeight: 200,
      body: Column(
        children: [
          FilledButton.tonal(
            onPressed: () => viewModel
                .selectChangeModeType(SerialTransactionChangeMode.onlyThisOne),
            child: Text("Only this one", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)),
          ),
          FilledButton.tonal(
            onPressed: () => viewModel
                .selectChangeModeType(SerialTransactionChangeMode.thisAndAllBefore),
            child: Text("All before", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)),
          ),
          FilledButton.tonal(
            onPressed: () => viewModel
                .selectChangeModeType(SerialTransactionChangeMode.thisAndAllAfter),
            child: Text("All afterwards", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)),
          ),
          FilledButton.tonal(
            onPressed: () => viewModel
                .selectChangeModeType(SerialTransactionChangeMode.all),
            child: Text("All", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
