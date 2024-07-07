import 'package:flutter/material.dart';
import 'package:linum/screens/budget_screen/widgets/budget_section_form.dart';

class AddBudgetSectionButton extends StatelessWidget {
  const AddBudgetSectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            showDragHandle: true,
            builder: (context) {
              return const BudgetSectionForm();
            },
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Card.outlined(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              "Neuer Abschnitt",
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.outlineVariant),
            ),
          ),
        ),
      ),
    );
  }
}
