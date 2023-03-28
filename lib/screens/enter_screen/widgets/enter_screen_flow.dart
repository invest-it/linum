import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/enums/enter_screen_view_state.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/views/change_mode_selector.dart';
import 'package:linum/screens/enter_screen/widgets/views/enter_screen_form.dart';
import 'package:linum/screens/enter_screen/widgets/views/entry_type_selector.dart';
import 'package:provider/provider.dart';



class EnterScreenFlow extends StatelessWidget {
  const EnterScreenFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EnterScreenViewModel>();

    switch(viewModel.viewState) {
      case EnterScreenViewState.selectEntryType:
        return const EntryTypeSelector();
      case EnterScreenViewState.enter:
        return const EnterScreenForm();
      case EnterScreenViewState.selectChangeMode:
        return const ChangeModeSelector();
    }
  }
}
