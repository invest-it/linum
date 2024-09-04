import 'package:flutter/material.dart';
import 'package:linum/screens/budget_screen/budget_routes.dart';
import 'package:linum/screens/budget_screen/budget_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class BudgetSplashScreen extends StatelessWidget {
  const BudgetSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<BudgetScreenViewModel>();
    return Column(
      children: [
        const Text("Hello Splash"),
        FilledButton(
            onPressed: () {
              viewModel.goTo(BudgetRoutes.wizard, replace: true);
            },
            child: const Text("Wizard"),
        ),
      ],
    );
  }
}
