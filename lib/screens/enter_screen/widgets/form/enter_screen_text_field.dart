import 'package:flutter/material.dart';
import 'package:linum/common/utils/debug.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_text_field_view_model.dart';
import 'package:provider/provider.dart';

class EnterScreenTextField extends StatelessWidget {
  final GlobalKey _key = LabeledGlobalKey("text_field");

  EnterScreenTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: 16,
      letterSpacing: 1.0,
    );
    return ChangeNotifierProxyProvider<
        EnterScreenFormViewModel,
        EnterScreenTextFieldViewModel
    >(
      create: (context) => EnterScreenTextFieldViewModel(
          context,
          textFieldKey: _key,
      ),
      update: (context, formViewModel, textFieldViewModel) {
        if (textFieldViewModel == null) {
          return EnterScreenTextFieldViewModel(
            context,
            textFieldKey: _key,
          );
        }
        if (formViewModel.entryType != textFieldViewModel.entryType) {
          debug("'${textFieldViewModel.textController.text}'");
          return EnterScreenTextFieldViewModel(
            context,
            textFieldKey: _key,
            prevControllerText: textFieldViewModel.textController.trueText,
          );
        }
        return textFieldViewModel;
      },
      builder: (context, _) {
        final textFieldViewModel = context.watch<EnterScreenTextFieldViewModel>();
        return Stack(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: baseTextStyle,
              key: _key,
              controller: textFieldViewModel.textController,
            ),
          ],
        );
      },
    );
  }

}
// TODO maybe use another provider for this
