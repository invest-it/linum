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
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
          child: Text(
            "Choose Entry Type",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {
                  viewModel.entryType = EntryType.expense;
                },
                style: FilledButton.styleFrom(
                  fixedSize: Size(
                      context.proportionateScreenWidthFraction(ScreenFraction.twofifths),
                      20,
                  ),
                ),
                icon: const Icon(
                  Icons.south_east,
                  color: Colors.red,
                ),
                label: Text("Expense", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white)),
              ),
              const SizedBox(
                width: 30,
              ),
              FilledButton.icon(
                onPressed: () {
                  viewModel.entryType = EntryType.income;
                },
                style: FilledButton.styleFrom(
                  fixedSize: Size(
                    context.proportionateScreenWidthFraction(ScreenFraction.twofifths),
                    20,
                  ),
                ),
                icon: const Icon(
                  Icons.north_east,
                  color: Colors.green,
                ),
                label: Text(
                    "Income",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
