import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/menu_action_button.dart';

class LinumCloseButton extends StatelessWidget {
  final EdgeInsets padding;
  const LinumCloseButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 24.0),
  });

  @override
  Widget build(BuildContext context) {
    return MenuActionButton(
      label: tr(translationKeys.enterScreen.button.close),
      padding: padding,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
