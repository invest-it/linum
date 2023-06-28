import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/abort_button.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/continue_button.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/delete_button.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/entry_type_switch.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_scaffold.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_text_field.dart';
import 'package:linum/screens/enter_screen/widgets/quick_tag_menu.dart';
import 'package:provider/provider.dart';

class EnterScreenForm extends StatelessWidget {
  const EnterScreenForm({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProxyProvider<EnterScreenViewModel, EnterScreenFormViewModel>(
      create: (context) {
        return EnterScreenFormViewModel(context);
      },
      update: (context, viewModel, formViewModel) {
        if (formViewModel == null) {
          return EnterScreenFormViewModel(context);
        }
        if (viewModel.entryType != formViewModel.entryType) {
          return EnterScreenFormViewModel(context);
        }
        return formViewModel;
      },
      child: EnterScreenScaffold(
        bodyHeight: 400 + useKeyBoardHeight(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),

                        child: EnterScreenTextField(),
                      ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 55,
                      top: 18,
                      bottom: 10,
                    ),
                    child: EnterScreenAbortButton(),
                  ),
                ],
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: QuickTagMenu(),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                child: const Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EnterScreenDeleteButton(),
                    EnterScreenEntryTypeSwitch(),
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
