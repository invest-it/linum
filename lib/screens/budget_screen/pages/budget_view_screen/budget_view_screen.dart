import 'package:flutter/material.dart';
import 'package:linum/common/widgets/loading_spinner.dart';
import 'package:linum/screens/budget_screen/budget_screen_viewmodel.dart';
import 'package:linum/screens/budget_screen/pages/budget_view_screen/widgets/sub_budget_tile.dart';
import 'package:provider/provider.dart';



class BudgetViewScreen extends StatelessWidget {
  const BudgetViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<BudgetScreenViewModel>();


    return FutureBuilder(
      future: viewModel.getBudgetViewData(DateTime.now()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.requireData.length,
              itemBuilder: (BuildContext context, int index) {
                return SubBudgetTile(budgetData: snapshot.requireData[index]);
              },
          );
        }
        return const LoadingSpinner();
      },
    );
  }
}
