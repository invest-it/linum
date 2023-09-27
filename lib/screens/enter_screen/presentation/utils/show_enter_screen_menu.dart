import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/menu/enter_screen_menu_scaffold.dart';
import 'package:provider/provider.dart';

void showEnterScreenMenu({
      required BuildContext context,
      String? title,
      required Widget content,
}) {
  final viewModel = context.read<EnterScreenViewModel>();
  final controller = showBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return EnterScreenMenuScaffold(title: title, content: content);
    },
  );
  viewModel.isBottomSheetOpened = true;

  controller.closed.then((value) => viewModel.isBottomSheetOpened = false);
}
