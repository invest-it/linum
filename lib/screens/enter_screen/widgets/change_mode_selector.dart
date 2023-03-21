import 'package:flutter/material.dart';

class ChangeModeSelector extends StatelessWidget {
  const ChangeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.tonal(
          onPressed: () {
          },
          child: Text("All before", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)),
        ),
        FilledButton.tonal(
          onPressed: () {
          },
          child: Text("Only current", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)),
        ),
        FilledButton.tonal(
          onPressed: () {
          },
          child: Text("All afterwards", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)),
        ),
      ],
    );
  }
}
