import 'package:flutter/material.dart';

class BudgetForm extends StatefulWidget {
  const BudgetForm({super.key});

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  late final TextEditingController _controller = TextEditingController(
    text: "249,95 €",
  );
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _controller,
            style: theme.textTheme.displayLarge,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SegmentedButton(
                  segments: [
                    ButtonSegment(
                      value: "expense",
                      label: Text(
                        "Ausgaben",
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    ButtonSegment(
                      value: "income",
                      label: Text(
                        "Einnahmen",
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ],
                  selected: const {"income",},
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
