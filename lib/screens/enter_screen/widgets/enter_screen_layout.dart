import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_form.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_type_selector.dart';
import 'package:provider/provider.dart';

class EnterScreenLayout extends StatelessWidget {
  const EnterScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EnterScreenViewModel>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: viewModel.calculateMaxHeight(context),
      ),
      child: Scaffold(
        body: Container(
          child: viewModel.entryType == EntryType.unknown
            ? const EnterScreenTypeSelector()
            : const EnterScreenForm(),
        ),
      ),
    );
  }
}
