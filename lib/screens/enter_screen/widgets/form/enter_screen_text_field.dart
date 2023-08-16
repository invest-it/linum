import 'package:flutter/material.dart';
import 'package:linum/common/utils/base_translator.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_text_field_view_model.dart';
import 'package:provider/provider.dart';

class EnterScreenTextField extends StatelessWidget {

  const EnterScreenTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: 16,
      letterSpacing: 1.0,
      textBaseline: TextBaseline.alphabetic,

    );
    return ChangeNotifierProxyProvider<
        EnterScreenFormViewModel,
        EnterScreenTextFieldViewModel
    >(
      create: (context) => EnterScreenTextFieldViewModel(
          context, BaseTranslator(),
      ),
      update: (context, formViewModel, textFieldViewModel) {
        if (textFieldViewModel == null) {
          return EnterScreenTextFieldViewModel(
            context, BaseTranslator(),
          );
        }
        textFieldViewModel.handleUpdate(context);
        return textFieldViewModel;
      },
      builder: (context, _) {
        final textFieldViewModel = context.watch<EnterScreenTextFieldViewModel>();
        return Stack(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              autofocus: true,
              style: baseTextStyle,
              key: textFieldViewModel.textFieldKey,
              controller: textFieldViewModel.textController,
              textAlignVertical: TextAlignVertical.bottom,
            ),
            // TODO: Add error line
          ],
        );
      },
    );
  }

}
// TODO maybe use another provider for this
