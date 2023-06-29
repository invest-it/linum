import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/menu_action_button.dart';
import 'package:provider/provider.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final formViewModel = context.read<EnterScreenFormViewModel>();
    final notes = formViewModel.data.notes;
    final textController = TextEditingController(
      text: (notes != null && notes != "") ? notes : null,
    );
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: tr("enter_screen.enter-note-hint"),
              ),
            ),
          ),
          MenuActionButton(
            label: tr("enter_screen.button.save-note"),
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            onPressed: () {
              formViewModel.data = formViewModel.data.copyWith(
                notes: textController.text,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
