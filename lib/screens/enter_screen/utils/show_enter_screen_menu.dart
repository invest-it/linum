import 'package:flutter/material.dart';
import 'package:linum/objectbox.g.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_menu.dart';
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
      return EnterScreenMenu(title: title, content: content);
    },
  );
  viewModel.isBottomSheetOpened = true;

  controller.closed.then((value) => viewModel.isBottomSheetOpened = false);
}
