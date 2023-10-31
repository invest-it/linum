import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_view_model.dart';
import 'package:provider/provider.dart';

class EnterScreenDeleteButton extends StatelessWidget {
  const EnterScreenDeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnterScreenViewModel>(builder: (context, viewModel, _) {
      if (viewModel.initialTransaction == null && viewModel.initialSerialTransaction == null) {
        return Container(
          padding: const EdgeInsets.all(15),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
          ),
        );
      }
      return GestureDetector(
        onTap: () => viewModel.delete(),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).colorScheme.error,
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
          ),
        ),
      );
    },);
  }
}
