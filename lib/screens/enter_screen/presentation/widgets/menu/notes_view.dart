import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/abort_button.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/menu_action_button.dart';
import 'package:provider/provider.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final formViewModel = context.read<EnterScreenFormViewModel>();
    final notes = formViewModel.data.options.notes;
    final textController = TextEditingController(
      text: (notes != null && notes != "") ? notes : null,
    );
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: tr(translationKeys.enterScreen.enterNoteHint),
                      ),
                    ),
                  ),
                  const EnterScreenAbortButton(),
                ],
              ),
            ),
            MenuActionButton(
              label: tr(translationKeys.enterScreen.button.saveNote),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              onPressed: () {
                formViewModel.data = formViewModel.data.copyWithOptions(
                  notes: textController.text,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
