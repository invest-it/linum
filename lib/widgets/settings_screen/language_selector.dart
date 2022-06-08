import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/country_flag_generator.dart';
import 'package:linum/widgets/settings_screen/toggle_button_element.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    Key? key,
    required this.accountSettingsProvider,
  }) : super(key: key);

  final AccountSettingsProvider accountSettingsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(
            AppLocalizations.of(context)!.translate(
              'settings_screen/language-settings/label-systemlang',
            ),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          value: accountSettingsProvider.settings['systemLanguage'] as bool? ??
              true,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (bool value) {
            accountSettingsProvider.updateSettings({'systemLanguage': value});
          },
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            ToggleButtons(
              isSelected: [
                accountSettingsProvider.settings['languageCode'] == 'de-DE',
                accountSettingsProvider.settings['languageCode'] == 'en-US',
                accountSettingsProvider.settings['languageCode'] == 'nl-NL',
                accountSettingsProvider.settings['languageCode'] == 'es-ES',
                accountSettingsProvider.settings['languageCode'] == 'fr-FR'
              ],
              onPressed:
                  accountSettingsProvider.settings['systemLanguage'] == false
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
                          accountSettingsProvider.updateSettings(
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