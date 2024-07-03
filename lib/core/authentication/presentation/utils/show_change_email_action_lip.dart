import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/sheets/linum_bottom_sheet.dart';
import 'package:linum/core/authentication/presentation/widgets/change_email_action_lip/change_email_bottom_sheet.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/generated/translation_keys.g.dart';

void showChangeEmailBottomSheet(BuildContext context, ScreenKey screenKey) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return LinumBottomSheet(
            title: tr(translationKeys.actionLip.changeEmail.labelTitle),
            body: const ChangeEmailBottomSheet(),
        );
      },
  );
}
