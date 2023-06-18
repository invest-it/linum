import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_text_field_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_hightlights.dart';
import 'package:provider/provider.dart';

class EnterScreenTextField extends StatelessWidget {
  final double paddingX;
  final GlobalKey _key = LabeledGlobalKey("text_field");

  EnterScreenTextField({
    super.key,
    required this.paddingX,
  });

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: 16,
      letterSpacing: 1.0,
    );
    return ChangeNotifierProxyProvider<EnterScreenFormViewModel, EnterScreenTextFieldViewModel>(
      create: (context) => EnterScreenTextFieldViewModel(context, _key),
      update: (context, formViewModel, textViewModel) {
        if (textViewModel == null) {
          return EnterScreenTextFieldViewModel(context, _key);
        }
        if (formViewModel.entryType != textViewModel.entryType) {
          return EnterScreenTextFieldViewModel(context, _key);
        }
        return textViewModel;
      },
      builder: (context, _) {
        final textViewModel = context.read<EnterScreenTextFieldViewModel>();
        return Stack(
          children: [
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.only(top: 6.0),
              child: EnterScreenHighlights(
                controller: textViewModel.textController,
                textScrollController: textViewModel.scrollController,
                textStyle: baseTextStyle,
                paddingY: paddingX,
                paddingX: 2.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingX),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: baseTextStyle,
                key: _key,
                controller: textViewModel.textController,
                scrollController: textViewModel.scrollController,
              ),
            ),
          ],
        );
      },
    );
  }

}
// TODO maybe use another provider for this
