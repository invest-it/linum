import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/localization/settings/utils/country_flag_generator.dart';
import 'package:linum/screens/onboarding_screen/constants/country_codes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void _handleOnDropdownChanged(BuildContext context, String? value) {
    if (value != null) {
      SharedPreferences.getInstance().then((pref) {
        pref.setString(
          "languageCode",
          countryFlagsToCountryCode[value] ?? "en",
        );
      });
      final String langString = countryFlagsToCountryCode[value] ?? "en";
      context.setLocale(
        Locale(
          langString,
          langString != "en" ? langString.toUpperCase() : "US",
        ),
      );

      context.read<AuthenticationService>().updateLanguageCode(
          context.locale.languageCode,
      );
    }
  }
}
