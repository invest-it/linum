import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:provider/provider.dart';

/// Depends on EnterScreenViewModel
class EnterScreenContinueButton extends StatelessWidget {
  const EnterScreenContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnterScreenViewModel>(builder: (context, viewModel, _) {
      // TODO: Can currently be implemented with Provider.of
      return GestureDetector(
        onTap: () => viewModel.next(),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Icon(
            Icons.arrow_forward_sharp,
            color: Colors.white,
          ),
        ),
      );
    },);
  }
}
