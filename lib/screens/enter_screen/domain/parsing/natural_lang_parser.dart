import 'package:linum/features/currencies/core/constants/standard_currencies.dart';
import 'package:linum/screens/enter_screen/domain/parsing/structured_parsed_data_builder.dart';

final amountRegex = RegExp(
  r"(?:(?<name1>[a-zA-Z]{4,140}) )?(?<currency1>[a-zA-Z\p{Sc}]{0,3}) ?(?<amount>-?[0-9]{1,9}[,.]?(?:[0-9]{1,2})?)? ?(?<currency2>[a-zA-Z\p{Sc}]{0,3})(?: (?<name2>.{4,140}))?$",
  unicode: true,
);

// Testable
class NaturalLangParser {
  final StructuredParsedDataBuilder parsedDataBuilder;

  NaturalLangParser(this.parsedDataBuilder);



  void parse(String input, String raw) {
    final matches = amountRegex.allMatches(input).toList();

    if (matches.isEmpty) {
      return;
    }
    final match = matches.toList()[0];


    var currencySubstr = match.namedGroup("currency1");

    final amountSubstr = match.namedGroup("amount");
    
    final secondCurrencyGroup = match.namedGroup("currency2");



    final firstNameGroup = match.namedGroup("name1");
    final secondNameGroup = match.namedGroup("name2");

    String? nameSubstr = firstNameGroup;

    if (isValidCurrency(secondCurrencyGroup)) {
      currencySubstr = secondCurrencyGroup;
    }

    if (secondNameGroup != null) {
      nameSubstr = secondNameGroup;
    }

    addParsedAmount(amountSubstr);
    addParsedCurrency(currencySubstr?.replaceAll("-", ""));
    addParsedName(nameSubstr);
  }

  void addParsedName(String? substring) {
    if (substring != null) {
      parsedDataBuilder.setName(
        substring,
        value: substring.trim(),
      );
    }
  }

  void addParsedAmount(String? substring) {
    final amount = double.tryParse(
      substring?.replaceAll(",", ".") ?? "",
    )?.abs();

    if (amount != null && substring != null) {
      parsedDataBuilder.setAmount(substring, amount);
    }
  }


  void addParsedCurrency(String? substring,) {
    final currency = getCurrencyFromSubstring(substring);
    if (currency != null && substring != null) {
      parsedDataBuilder.setCurrency(substring, currency);
    }
  }
}
