import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:provider/provider.dart';

/// Depends on EnterScreenViewModel
class EnterScreenButton extends StatelessWidget {
  const EnterScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnterScreenViewModel>(builder: (context, viewModel, _) {
      return GestureDetector(
        onTap: () => viewModel.save(),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Color(0xFF97BC4E),
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
