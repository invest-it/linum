import 'package:flutter/material.dart';
import 'package:linum/screens/budget_screen/pages/budget_wizard_screen/budget_wizard_routes.dart';
import 'package:linum/screens/budget_screen/pages/budget_wizard_screen/budget_wizard_screen_view_model.dart';
import 'package:provider/provider.dart';

class BudgetWizardScreen extends StatelessWidget {
  const BudgetWizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BudgetWizardScreenViewModel>(
      create: (context) {
        return BudgetWizardScreenViewModel();
      },
      builder: (context, widget) {
        return Navigator(
          key: context.read<BudgetWizardScreenViewModel>().navigatorKey,
          initialRoute: BudgetWizardRoutes.start,
          onGenerateRoute: (settings) {
            final page = switch(settings.name) {
              // TODO: Implement Screens
              BudgetWizardRoutes.start => const Text("Hello from wizard/start"),
              BudgetWizardRoutes.configMain => const Placeholder(),
              BudgetWizardRoutes.configSub => const Placeholder(),
              BudgetWizardRoutes.review => const Placeholder(),
              _ => throw StateError('Unexpected route name: ${settings.name}!'),
            };

            return MaterialPageRoute(
                builder: (context) {
                  return page;
                },
                settings: settings,
            );
          },
        );
      },
    );
  }
}
