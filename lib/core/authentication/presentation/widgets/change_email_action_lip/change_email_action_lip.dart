import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/presentation/widgets/change_email_action_lip/change_email_form.dart';
import 'package:linum/generated/translation_keys.g.dart';

class ChangeEmailActionLip extends StatelessWidget {
  const ChangeEmailActionLip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 24.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              tr(translationKeys.actionLip.changeEmail.labelDescription),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ChangeEmailForm(),
        ),
      ],
    );
  }
}
