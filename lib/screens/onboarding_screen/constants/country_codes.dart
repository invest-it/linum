//  Country Codes - Constant List of Supported Languages (NOTE: ADDING A LANGUAGE REQUIRES CHANGES IN MAIN.DART TOO!!!)
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:linum/common/utils/country_flag_generator.dart';

final countryFlagsToCountryCode = Map<String, String>.unmodifiable({
  countryFlag('de'): "de",
  countryFlag('gb'): "en",
  countryFlag('nl'): "nl",
  countryFlag('es'): "es",
  countryFlag('fr'): "fr",
});
