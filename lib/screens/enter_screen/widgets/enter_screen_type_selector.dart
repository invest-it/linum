import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:provider/provider.dart';

class EnterScreenTypeSelector extends StatelessWidget {
  const EnterScreenTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EnterScreenViewModel>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Choose the type of your transaction".toUpperCase(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () => viewModel.entryType = EntryType.expense,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.arrow_circle_down_rounded,
                          color: Colors.redAccent,
                          size: 60,
                        ),
                        Text(
                          "Expense",
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.black),

                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  width: context.proportionateScreenWidthFraction(ScreenFraction.onefifth),
                  thickness: 1.0,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () => viewModel.entryType = EntryType.income,
                    child: Column(
                      children: [
                        Icon(
                          Icons.arrow_circle_up_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 60,
                        ),
                        Text(
                          "Income",
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.black),

                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
