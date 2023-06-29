//  Settings Screen - Screen that allows changing user Settings as well as logging out, changing languages and performing "Danger Zone" tasks
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron

import 'package:flutter/material.dart';
import 'package:linum/common/utils/silent_scroll.dart';
import 'package:linum/common/widgets/list_divider.dart';
import 'package:linum/common/widgets/list_header.dart';
import 'package:linum/core/authentication/widgets/delete_user_button.dart';
import 'package:linum/core/authentication/widgets/forgot_password.dart';
import 'package:linum/core/authentication/widgets/logout_form.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/settings_screen/widget/language_selector.dart';
import 'package:linum/screens/settings_screen/widget/pin_switch.dart';
import 'package:linum/screens/settings_screen/widget/standard_category/standard_category_selector.dart';
import 'package:linum/screens/settings_screen/widget/standard_currency/standard_currency_selector.dart';
import 'package:linum/screens/settings_screen/widget/version_number.dart';

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
    return ScreenSkeleton(
      head: 'Account',
      screenKey: ScreenKey.settings,
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
            const StandardCategorySelector(),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // All Authentication Actions (including logOut will be handled via widgets/auth from now on.)
                LogoutForm(),
                ForgotPasswordButton(ScreenKey.settings),
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
