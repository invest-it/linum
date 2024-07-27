import 'package:flutter/material.dart';

class ForgotPasswordScaffold extends StatelessWidget {
  final String label;
  final Widget inputField;
  final VoidCallback callback;
  final String buttonLabel;
  final TextEditingController controller;
  const ForgotPasswordScaffold({
    super.key,
    required this.label,
    required this.inputField,
    required this.controller,
    required this.callback,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 24.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              label,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    inputField,
                  ],
                ),
              ),

              FilledButton(
                // Logged Out onPressed
                onPressed: callback,
                child: Text(
                  buttonLabel,
                  style: theme.textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 32,),
            ],
          ),
        ),
      ],
    );
  }
}
