//  Settings Screen - Screen that allows changing user Settings as well as logging out, changing languages and performing "Danger Zone" tasks
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron

import 'package:flutter/material.dart';
import 'package:linum/common/utils/silent_scroll.dart';
import 'package:linum/common/widgets/list_divider.dart';
import 'package:linum/common/widgets/list_header.dart';
import 'package:linum/core/authentication/presentation/widgets/change_email_button.dart';
import 'package:linum/core/authentication/presentation/widgets/delete_user_button.dart';
import 'package:linum/core/authentication/presentation/widgets/forgot_password.dart';
import 'package:linum/core/authentication/presentation/widgets/logout_button.dart';
import 'package:linum/core/authentication/presentation/widgets/logout_form.dart';
import 'package:linum/core/categories/settings/presentation/widgets/standard_category_selectors.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/core/localization/settings/presentation/widgets/language_selector.dart';
import 'package:linum/features/currencies/settings/presentation/widgets/standard_currency_selector.dart';
import 'package:linum/screens/settings_screen/widgets/pin_switch.dart';
import 'package:linum/screens/settings_screen/widgets/version_number.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
      head: 'Account',
      isInverted: true,
      screenKey: ScreenKey.settings,
      initialActionLipBody: Container(),
      body: Column(
        children: [
          LogoutForm(),
          Expanded(
            child: ScrollConfiguration(
              behavior: const SilentScroll(),
              child: ListView(
                key: const Key("accountListView"),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 24.0,
                ),
                children: [

                  /// STANDARD CATEGORY
                  const ListHeader(
                    'settings_screen.standard-category.label-title',
                    tooltipMessage: 'settings_screen.standard-category.label-tooltip',
                  ),
                  const StandardCategorySelectors(),
                  const ListDivider(),

                  /// PIN SWITCH
                  const ListHeader(
                    'settings_screen.pin-lock.label-title',
                    tooltipMessage: 'settings_screen.pin-lock.label-tooltip',
                  ),
                  const PinSwitch(),
                  const ListDivider(),

                  const ListHeader('settings_screen.standard-currency.label-title'),
                  const StandardCurrencySelector(),
                  const ListDivider(),

                  /// LANGUAGE SWITCH
                  const ListHeader(
                    'settings_screen.language-settings.label-title',
                  ),
                  const LanguageSelector(),
                  const ListDivider(),

                  /// YOUR ACCOUNT
                  const ListHeader('settings_screen.system-settings.label-title'),
                  const SizedBox(height: 16.0,),
                  const Wrap(
                    spacing: 8.0,
                    children: [
                      LogoutButton(),
                      ForgotPasswordButton(ScreenKey.settings),
                      ChangeEmailButton(ScreenKey.settings),
                      DeleteUserButton(),
                    ],
                  ),

                  /// VERSION NUMBER
                  VersionNumber(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
