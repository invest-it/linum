import 'package:flutter/material.dart';
import 'package:linum/common/widgets/text_icon.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:provider/provider.dart';

class BudgetForm extends StatelessWidget {
  const BudgetForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencySettings = context.read<ICurrencySettingsService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Budget setzen", style: theme.textTheme.headlineMedium,),
        Text("Wie viel Geld möchtest du maximal ausgeben?", style: theme.textTheme.bodyMedium),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: TextIcon(currencySettings.getStandardCurrency().symbol),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        DropdownMenu(
          initialSelection: "monthly",
          menuStyle: MenuStyle(
            backgroundColor: MaterialStateProperty.all(theme.colorScheme.background),
            // TODO: Change the color
          ),
          dropdownMenuEntries: const [
            DropdownMenuEntry(value: "monthly", label: "Monatlich"),
            DropdownMenuEntry(value: "yearly", label: "Jährlich"),
          ],
        ),
      ],
    );
  }
}
