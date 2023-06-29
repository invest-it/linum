import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/entry_type_button.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_scaffold.dart';
import 'package:provider/provider.dart';

class EntryTypeSelectionView extends StatelessWidget {
  const EntryTypeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EnterScreenViewModel>();
    return EnterScreenScaffold(
      bodyHeight: 200,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              tr("enter_screen.entry-type-selection.title").toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EntryTypeButton(
                      title: tr("enter_screen.button.expenses-label"),
                      iconData: Icons.arrow_circle_down_rounded,
                      iconColor: Theme.of(context).colorScheme.error,
                      onTap: () => viewModel.selectEntryType(EntryType.expense),
                  ),
                  VerticalDivider(
                      width: context
                          .proportionateScreenWidthFraction(ScreenFraction.onefifth),
                      thickness: 1.0,
                      color: Colors.grey,
                  ),
                  EntryTypeButton(
                      title: tr("enter_screen.button.income-label"),
                      iconData: Icons.arrow_circle_up_rounded,
                      iconColor: Theme.of(context).colorScheme.primary,
                      onTap: () => viewModel.selectEntryType(EntryType.income),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
