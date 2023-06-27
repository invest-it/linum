import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/common/utils/debug.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:provider/provider.dart';

class EnterScreenEntryTypeSwitch extends StatelessWidget {
  const EnterScreenEntryTypeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;

    return Consumer<EnterScreenViewModel>(
      builder: (context, viewModel, _) {
        final formViewModel = context.read<EnterScreenFormViewModel>();

        return SegmentedButton(
          onSelectionChanged: (selection) {
            debug(selection);
            if (selection.isEmpty) {
              return;
            }
            viewModel.entryType = selection.first;
            formViewModel.data = formViewModel.data.removeCategory();
          },
          segments: [
            ButtonSegment(
              value: EntryType.expense,
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("Expense", style: style?.copyWith(
                  color: viewModel.entryType == EntryType.expense
                      ? Colors.red
                      : Colors.black26,
                ),),
              ),
            ),
            ButtonSegment(
              value: EntryType.income,
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text("Income", style: style?.copyWith(
                    color: viewModel.entryType == EntryType.income
                        ? Colors.lightGreen
                        : Colors.black26,
                ),),
              ),
            ),
          ],
          selected: {viewModel.entryType},
          showSelectedIcon: false,
        );
      },
    );
  }
}
