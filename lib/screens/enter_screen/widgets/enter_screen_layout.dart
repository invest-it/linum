import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_button.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_text_field.dart';
import 'package:linum/screens/enter_screen/widgets/quick_tag_menu.dart';
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
          padding: EdgeInsets.only(
            top: 25,
            bottom: 25 + useKeyBoardHeight(context),
          ),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: const EnterScreenTextField(),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: QuickTagMenu(),
                    ),
                    SizedBox(width: 24),
                    EnterScreenButton()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
