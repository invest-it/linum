import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/continue_button.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/delete_button.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_scaffold.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_text_field.dart';
import 'package:linum/screens/enter_screen/widgets/quick_tag_menu.dart';
import 'package:provider/provider.dart';

class EnterScreenForm extends StatelessWidget {
  const EnterScreenForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EnterScreenFormViewModel>(
      create: (context) {
        return EnterScreenFormViewModel(context);
      },
      child: EnterScreenScaffold(
        bodyHeight: 300 + useKeyBoardHeight(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: const EnterScreenTextField(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: QuickTagMenu(),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    EnterScreenDeleteButton(),
                    EnterScreenContinueButton()
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
