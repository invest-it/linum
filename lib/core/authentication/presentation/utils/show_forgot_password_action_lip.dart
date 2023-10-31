import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/authentication/presentation/widgets/forgot_password_action_lip/registered_user_forgot_password_action_lip.dart';
import 'package:linum/core/authentication/presentation/widgets/forgot_password_action_lip/unregistered_user_forgot_password_action_lip.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';

void showForgotPasswordActionLip(BuildContext context, ScreenKey screenKey) {
  // lip if the user is not logged in
  final viewModel = context.read<ActionLipViewModel>();
  final authService = context.read<AuthenticationService>();

  final TextEditingController inputController = TextEditingController();

  if (!authService.isLoggedIn) {
    viewModel.setActionLip(
      context: context,
      screenKey: screenKey,
      actionLipBody: UnregisteredUserForgotPasswordActionLip(
          controller: inputController,
      ),
      actionLipStatus: ActionLipVisibility.onviewport,
      actionLipTitle:
      tr(translationKeys.actionLip.forgotPassword.loggedOut.labelTitle),
    );
  }
  // lip if the user has already authenticated themself
  else {
    viewModel.setActionLip(
      context: context,
      screenKey: screenKey,
      actionLipBody: RegisteredUserForgotPasswordActionLip(
          controller: inputController,
      ),
      actionLipStatus: ActionLipVisibility.onviewport,
      actionLipTitle:
      tr(translationKeys.actionLip.forgotPassword.loggedIn.labelTitle),
    );
  }
}
