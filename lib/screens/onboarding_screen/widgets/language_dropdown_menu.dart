import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/localization/settings/constants/supported_locales.dart';
import 'package:linum/core/localization/settings/presentation/language_settings_service.dart';
import 'package:linum/core/localization/settings/utils/country_flag_generator.dart';
import 'package:linum/screens/onboarding_screen/constants/country_codes.dart';
import 'package:provider/provider.dart';

class LanguageDropDownMenu extends StatelessWidget {
  const LanguageDropDownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        elevation: 1,
        items: countryFlagsToCountryCode.keys
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        value: countryFlagWithSpecialCases(
          context.locale.languageCode,
        ),
        onChanged: (value) => _handleOnDropdownChanged(
          context,
          value,
        ),
      ),
    );
  }

  Future _handleOnDropdownChanged(BuildContext context, String? value) async {
    if (value != null) {
      final String langCode = countryFlagsToCountryCode[value] ?? "en";

      final languageTag = supportedLocales.firstWhereOrNull((l) => l.languageCode == langCode)?.toLanguageTag();

      await context.read<ILanguageSettingsService>().setLanguageTag(languageTag);

    }
  }
}
