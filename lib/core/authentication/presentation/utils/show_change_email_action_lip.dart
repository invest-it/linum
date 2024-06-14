import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/common/components/sheets/linum_bottom_sheet.dart';
import 'package:linum/core/authentication/presentation/widgets/change_email_action_lip/change_email_bottom_sheet.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';

void showChangeEmailBottomSheet(BuildContext context, ScreenKey screenKey) {
  final viewModel = context.read<ActionLipViewModel>();

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
