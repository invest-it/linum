//  Settings Screen Language Selector - The toggle to decide whether to use system language and the selector to decide between languages
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  Partly refactored: damattl and TheBlueBaron

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/localization/settings/presentation/language_settings_service.dart';
import 'package:linum/core/localization/settings/utils/country_flag_generator.dart';
import 'package:linum/screens/settings_screen/widgets/toggle_button_element.dart';
import 'package:provider/provider.dart';




class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final languageSettingsService = context.watch<ILanguageSettingsService>();

    return Column(
      children: [
        SwitchListTile(
          title: Text(
            'settings_screen.language-settings.label-systemlang',
            style: Theme.of(context).textTheme.bodyLarge,
          ).tr(),
          value: languageSettingsService.useSystemLanguage,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (bool value) {
            languageSettingsService.setUseSystemLanguage(value);
          },
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            ToggleButtons(
              isSelected: [
                languageSettingsService.isCurrentLanguageCode('de-DE'),
                languageSettingsService.isCurrentLanguageCode('en-US'),
                languageSettingsService.isCurrentLanguageCode('nl-NL'),
                languageSettingsService.isCurrentLanguageCode('es-ES'),
                languageSettingsService.isCurrentLanguageCode('fr-FR')
              ],
              onPressed: _selectLanguage(languageSettingsService),
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

  Function(int value)? _selectLanguage(ILanguageSettingsService languageSettingsService) {
    if (languageSettingsService.useSystemLanguage) {
      return null;
    }

    return (value) {
      String langSelector;
      switch (value) {
        case 0:
          langSelector = 'de-DE';
        case 1:
          langSelector = 'en-US';
        case 2:
          langSelector = 'nl-NL';
        case 3:
          langSelector = 'es-ES';
        case 4:
          langSelector = 'fr-FR';
        default:
          langSelector = 'en-US';
      }
      languageSettingsService.setLanguageCode(langSelector);
    };
  }
}
