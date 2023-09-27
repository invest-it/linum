import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/presentation/enums/enter_screen_view_state.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/views/change_mode_selection_view.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/views/enter_screen_form_view.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/views/entry_type_selection_view.dart';
import 'package:provider/provider.dart';



class EnterScreenFlow extends StatelessWidget {
  const EnterScreenFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EnterScreenViewModel>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1.5),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: _nextView(viewModel.viewState),
    );

  }

  Widget _nextView(EnterScreenViewState viewState) {
    switch(viewState) {
      case EnterScreenViewState.selectEntryType:
        return const EntryTypeSelectionView();
      case EnterScreenViewState.enter:
        return const EnterScreenFormView();
      case EnterScreenViewState.selectChangeMode:
        return const ChangeModeSelectionView();
    }
  }
}
