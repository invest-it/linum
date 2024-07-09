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
  final mediaQuery = MediaQuery.of(context);
  final view = View.of(context);
  final controller = showBottomSheet(
    constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height - view.viewPadding.top / view.devicePixelRatio,
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
          child: EnterScreenMenuScaffold(title: title, content: content)
      );
    },
    enableDrag: true,
    showDragHandle: true,
  );
  viewModel.isBottomSheetOpened = true;
  controller.closed.then((value) => viewModel.isBottomSheetOpened = false);
}
