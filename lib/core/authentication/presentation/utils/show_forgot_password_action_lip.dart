import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/sheets/linum_bottom_sheet.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/authentication/presentation/widgets/forgot_password_action_lip/registered_user_forgot_password_bottom_sheet.dart';
import 'package:linum/core/authentication/presentation/widgets/forgot_password_action_lip/unregistered_user_forgot_password_bottom_sheet.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';

void showForgotPasswordBottomSheet(BuildContext context, ScreenKey screenKey) {
  // lip if the user is not logged in
  final authService = context.read<AuthenticationService>();

  final TextEditingController inputController = TextEditingController();

  if (!authService.isLoggedIn) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
            return LinumBottomSheet(
              title: tr(translationKeys.actionLip.forgotPassword.loggedOut.labelTitle),
              body: UnregisteredUserForgotPasswordBottomSheet(
                controller: inputController,
              ),
          );
        },
    );
  }
  // lip if the user has already authenticated themself
  else {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return LinumBottomSheet(
          title: tr(translationKeys.actionLip.forgotPassword.loggedIn.labelTitle),
          body: RegisteredUserForgotPasswordBottomSheet(
            controller: inputController,
          ),
        );
      },
    );

  }
}
