import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/utils/parsing/get_text_indices.dart';

final amountRegex = RegExp(
  r"(?:(?<name1>\w{4,140}) )?(?<currency1>[a-zA-Z\p{Sc}]{0,3}) ?(?<amount>-?[0-9]{1,9}[,.]?(?:[0-9]{1,2})?)? ?(?<currency2>[a-zA-Z\p{Sc}]{0,3})(?: (?<name2>.{4,140}))?$",
  unicode: true,
);

class NaturalLangParser {
  final List<ParsedInput> parsedInputs = [];


  List<ParsedInput> parse(String input, String raw) {
    final matches = amountRegex.allMatches(input).toList();

    if (matches.isEmpty) {
      return parsedInputs;
      // TODO: find a better way
    }
    final match = matches.toList()[0];


    var currencySubstr = match.namedGroup("currency1");
    var currencyIndices = getTextIndices(currencySubstr, raw);

    final amountSubstr = match.namedGroup("amount");
    final amountIndices = getTextIndices(amountSubstr, raw);

    final secondCurrencyGroup = match.namedGroup("currency2");



    final firstNameGroup = match.namedGroup("name1");
    final secondNameGroup = match.namedGroup("name2");

    String? nameSubstr = firstNameGroup;

    if (isValidCurrency(secondCurrencyGroup)) {
      currencySubstr = secondCurrencyGroup;
      currencyIndices = getTextIndices(currencySubstr, raw);
    }

    if (secondNameGroup != null) {
      nameSubstr = secondNameGroup;
    }

    final nameIndices = getTextIndices(nameSubstr, raw);

    addParsedAmount(amountSubstr, amountIndices);
    addParsedCurrency(
        currencySubstr?.replaceAll("-", ""),
        currencyIndices,
    );
    addParsedName(nameSubstr, nameIndices);

    return parsedInputs;
  }

  void addParsedName(
      String? substr,
      TextIndices? indices,
      ) {
    if (substr != null) {
      parsedInputs.add(
        ParsedInput<String>(
          type: InputType.name,
          value: substr.trim(),
          raw: substr,
          indices: indices!,
        ),
      );
    }
  }

  void addParsedAmount(
      String? substr,
      TextIndices? indices,
      ) {
    final amount = double.tryParse(
      substr?.replaceAll(",", ".") ?? "",
    )?.abs();

    if (amount != null && substr != null) {
      parsedInputs.add(
        ParsedInput<double>(
          type: InputType.amount,
          value: amount,
          raw: substr,
          indices: indices!,
        ),
      );
    }
  }


  void addParsedCurrency(
      String? substr,
      TextIndices? indices,
  ) {
    final currency = getCurrencyFromSubstring(substr);
    if (currency != null && substr != null) {
      parsedInputs.add(
        ParsedInput<Currency>(
          type: InputType.currency,
          value: currency,
          raw: substr,
          indices: indices!,
        ),
      );
    }
  }
}
