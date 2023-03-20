import 'package:collection/collection.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/utils/parsing/get_text_indices.dart';
import 'package:tuple/tuple.dart';

final amountRegex = RegExp(
  r'([a-zA-Z\p{Sc}]{0,3}) ?([0-9]+[,.]?(?:[0-9]{1,2})?) ?([a-zA-Z\p{Sc}]{0,3})(?: (.{0,140}))?$',
  unicode: true,
);

EnterScreenInput parseBaseInfo(String input, String raw) {
  final matches = amountRegex.allMatches(input).toList();
  if (matches.isEmpty) {
    return EnterScreenInput(raw, currency: "EUR");
    // TODO: find a better way
  }
  final match = matches.toList()[0];

  var currency = match.group(1);
  var currencyIndices = getTextIndices(currency, raw);

  final amount = match.group(2);
  final amountIndices = getTextIndices(amount, raw);

  if (match.group(3) != null && match.group(3) != "") {
    currency = match.group(3);
    currencyIndices = getTextIndices(currency, raw);
  }
  final name = match.group(4)?.trim();
  final nameIndices = getTextIndices(name, raw);

  if (currency != null) {
    raw.indexOf(currency);

    final cur = standardCurrencies[currency];
    if (cur == null) {
      if (currency == "\$") {
        currency = "US\$";
      }
      currency = standardCurrencies.entries
          .firstWhereOrNull((element) => element.value.symbol == currency)
          ?.key;
    }
  }

  if (amount == null) {
    return EnterScreenInput(raw, currency: currency);
  }

  currency ??= "EUR";

  final value = double.tryParse(amount.replaceAll(",", ".")) ?? 0;

  return EnterScreenInput(
      raw,
      amount: value,
      amountIndices: amountIndices,
      currency: currency,
      currencyIndices: currencyIndices,
      name: name,
      nameIndices: nameIndices,
  );
}
