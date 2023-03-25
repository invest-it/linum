//  Settings Screen Language Selector - The toggle to decide whether to use system language and the selector to decide between languages
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  Partly refactored: damattl and TheBlueBaron

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/country_flag_generator.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/screens/settings_screen/widget/toggle_button_element.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final accountSettingsService = context.watch<AccountSettingsService>();

    return Column(
      children: [
        SwitchListTile(
          title: Text(
            'settings_screen.language-settings.label-systemlang',
            style: Theme.of(context).textTheme.bodyText1,
          ).tr(),
          value: accountSettingsService.settings['systemLanguage'] as bool? ??
              true,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (bool value) {
            accountSettingsService.updateSettings({'systemLanguage': value});
          },
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            ToggleButtons(
              isSelected: [
                accountSettingsService.settings['languageCode'] == 'de-DE',
                accountSettingsService.settings['languageCode'] == 'en-US',
                accountSettingsService.settings['languageCode'] == 'nl-NL',
                accountSettingsService.settings['languageCode'] == 'es-ES',
                accountSettingsService.settings['languageCode'] == 'fr-FR'
              ],
              onPressed:
                  accountSettingsService.settings['systemLanguage'] == false
                      ? (int index) {
                          String langSelector;
                          switch (index) {
                            case 0:
                              langSelector = 'de-DE';
                              break;
                            case 1:
                              langSelector = 'en-US';
                              break;
                            case 2:
                              langSelector = 'nl-NL';
                              break;
                            case 3:
                              langSelector = 'es-ES';
                              break;
                            case 4:
                              langSelector = 'fr-FR';
                              break;
                            default:
                              langSelector = 'en-US';
                          }
                          accountSettingsService.updateSettings(
                            {'languageCode': langSelector},
                          );
                        }
                      : null,
              borderRadius: BorderRadius.circular(32),
              children: [
                ToggleButtonElement(countryFlag('de')),
                ToggleButtonElement(countryFlag('gb')),
                ToggleButtonElement(countryFlag('nl')),
                ToggleButtonElement(countryFlag('es')),
                ToggleButtonElement(countryFlag('fr')),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
