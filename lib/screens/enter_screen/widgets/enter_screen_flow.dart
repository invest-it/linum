import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/enums/enter_screen_view_state.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/views/change_mode_selection_view.dart';
import 'package:linum/screens/enter_screen/widgets/views/enter_screen_form_view.dart';
import 'package:linum/screens/enter_screen/widgets/views/entry_type_selection_view.dart';
import 'package:provider/provider.dart';



class EnterScreenFlow extends StatelessWidget {
  const EnterScreenFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EnterScreenViewModel>();


    switch(viewModel.viewState) {
      case EnterScreenViewState.selectEntryType:
        return const EntryTypeSelectionView();
      case EnterScreenViewState.enter:
        return const EnterScreenFormView();
      case EnterScreenViewState.selectChangeMode:
        return const ChangeModeSelectionView();
    }
  }
}
