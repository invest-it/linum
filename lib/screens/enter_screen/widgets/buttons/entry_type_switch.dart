import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/generated/translation_keys.g.dart';
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
            if (selection.isEmpty) {
              return;
            }
            viewModel.entryType = selection.first;
            formViewModel.data = formViewModel.data.removeCategoryAndCopy();
          },
          segments: [
            ButtonSegment(
              value: EntryType.expense,
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(tr(translationKeys.enterScreen.button.expensesLabel), style: style?.copyWith(
                  color: viewModel.entryType == EntryType.expense
                      ? Theme.of(context).colorScheme.error
                      : Colors.black26,
                ),),
              ),
            ),
            ButtonSegment(
              value: EntryType.income,
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(tr(translationKeys.enterScreen.button.incomeLabel), style: style?.copyWith(
                    color: viewModel.entryType == EntryType.income
                        ? Theme.of(context).colorScheme.primary
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
