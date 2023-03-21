import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/change_mode_selector.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_form.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_type_selector.dart';
import 'package:provider/provider.dart';

class EnterScreenLayout extends StatelessWidget {
  const EnterScreenLayout({super.key});

  Widget selectView(EnterScreenViewModel viewModel) {
    if (viewModel.openChangeModeSelector) {
      return const ChangeModeSelector();
    }
    return viewModel.entryType == EntryType.unknown
        ? const EnterScreenTypeSelector()
        : const EnterScreenForm();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EnterScreenViewModel>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: viewModel.calculateMaxHeight(context),
      ),
      child: Scaffold(
        body: Container(
          child: selectView(viewModel),
        ),
      ),
    );
  }
}
