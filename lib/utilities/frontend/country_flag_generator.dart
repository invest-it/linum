//  Country Flag Generator - Takes String Inputs and returns the appropriate Emoji Flag
//  CAUTION: For this function to work, the input String must adhere to the ISO Guidelines.
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

String countryFlag(String countryCode) {
  final String flag = countryCode.toUpperCase().replaceAllMapped(
        RegExp('[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
      );
  return flag;
}

String countryFlagWithSpecialCases(String countryCode) {
  if (countryCode == "en") {
    return countryFlag("gb");
  } else {
    return countryFlag(countryCode);
  }
}
