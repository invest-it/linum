//  Settings Screen - Screen that allows changing user Settings as well as logging out, changing languages and performing "Danger Zone" tasks
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron
/// PAGE INDEX 3

import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/utilities/frontend/silent_scroll.dart';
import 'package:linum/widgets/auth/delete_user_button.dart';
import 'package:linum/widgets/auth/forgot_password.dart';
import 'package:linum/widgets/auth/logout_form.dart';
import 'package:linum/widgets/list_divider.dart';
import 'package:linum/widgets/list_header.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/settings_screen/language_selector.dart';
import 'package:linum/widgets/settings_screen/pin_switch.dart';
import 'package:linum/widgets/settings_screen/standard_category/standard_category_manager.dart';
import 'package:linum/widgets/settings_screen/standard_currency/standard_currency_manager.dart';
import 'package:linum/widgets/settings_screen/version_number.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);
    final PinCodeProvider pinCodeProvider =
        Provider.of<PinCodeProvider>(context);
    return ScreenSkeleton(
      head: 'Account',
      providerKey: ProviderKey.settings,
      initialActionLipBody: Container(),
      body: ScrollConfiguration(
        behavior: SilentScroll(),
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
            const StandardCategory(),
            const ListDivider(),

            /// PIN SWITCH
            const ListHeader(
              'settings_screen.pin-lock.label-title',
              tooltipMessage: 'settings_screen.pin-lock.label-tooltip',
            ),
            PinSwitch(pinCodeProvider: pinCodeProvider),
            const ListDivider(),

            const ListHeader("STANDARD-CURRENCY"),
            const StandardCurrencyManager(),
            const ListDivider(),

            /// LANGUAGE SWITCH
            const ListHeader(
              'settings_screen.language-settings.label-title',
            ),
            LanguageSelector(accountSettingsProvider: accountSettingsProvider),
            const ListDivider(),

            /// YOUR ACCOUNT
            const ListHeader('settings_screen.system-settings.label-title'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // All Authentication Actions (including logOut will be handled via widgets/auth from now on.)
                LogoutForm(),
                ForgotPasswordButton(ProviderKey.settings),
                const DeleteUserButton(),
              ],
            ),

            /// VERSION NUMBER
            VersionNumber(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
