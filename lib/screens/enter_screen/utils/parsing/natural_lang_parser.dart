import 'package:collection/collection.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/utils/parsing/get_text_indices.dart';

final amountRegex = RegExp(
  r'([a-zA-Z\p{Sc}]{0,3}) ?(-?[0-9]+[,.]?(?:[0-9]{1,2})?) ?([a-zA-Z\p{Sc}]{0,3})(?: (.{0,140}))?$',
  unicode: true,
);

class NaturalLangParser {
  List<ParsedInput> parse(String input, String raw) {
    final matches = amountRegex.allMatches(input).toList();

    final List<ParsedInput> parsedInputs = [];

    if (matches.isEmpty) {
      return parsedInputs;
      // TODO: find a better way
    }
    final match = matches.toList()[0];

    var currencySubstr = match.group(1);
    var currencyIndices = getTextIndices(currencySubstr, raw);

    final amountSubstr = match.group(2);
    final amountIndices = getTextIndices(amountSubstr, raw);

    if (match.group(3) != null && match.group(3) != "") {
      currencySubstr = match.group(3);
      currencyIndices = getTextIndices(currencySubstr, raw);
    }
    final nameSubstr = match.group(4)?.trim();
    final nameIndices = getTextIndices(nameSubstr, raw);

    addParsedAmount(amountSubstr, amountIndices, parsedInputs);
    addParsedCurrency(currencySubstr, currencyIndices, parsedInputs);
    addParsedName(nameSubstr, nameIndices, parsedInputs);

    return parsedInputs;
  }

  void addParsedName(
      String? substr,
      TextIndices? indices,
      List<ParsedInput> parsedInputs,
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
      List<ParsedInput> parsedInputs,
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
      List<ParsedInput> parsedInputs,
  ) {
    Currency? currency;
    if (substr != null) {
      currency = standardCurrencies[substr];
      currency ??= standardCurrencies.entries
          .firstWhereOrNull((element) => element.value.symbol == substr)?.value;
    }

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
