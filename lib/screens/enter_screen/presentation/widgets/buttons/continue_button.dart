import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_view_model.dart';
import 'package:provider/provider.dart';

/// Depends on EnterScreenViewModel
class EnterScreenContinueButton extends StatelessWidget {
  const EnterScreenContinueButton({super.key});

  Widget _buttonUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5000)),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: const Icon(
        Icons.arrow_forward_sharp,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EnterScreenViewModel>();
    final formViewModel = context.read<EnterScreenFormViewModel>();
    return GestureDetector(
      onTap: () => viewModel.next(
        data: formViewModel.data,
        defaultValues: formViewModel.defaultValues,
      ),
      child: _buttonUI(context),
    );
  }
}
