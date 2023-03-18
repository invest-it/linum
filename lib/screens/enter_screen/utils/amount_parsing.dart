import 'package:collection/collection.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';

final amountRegex = RegExp(
  r'([a-zA-Z\p{Sc}]{0,3}) ?([0-9]+[,.]?(?:[0-9]{1,2})?) ?([a-zA-Z\p{Sc}]{0,3})(?: (.{0,140}))?$',
  unicode: true,
);

EnterScreenInput parseAmount(String input, String raw) {
  final matches = amountRegex.allMatches(input).toList();
  if (matches.isEmpty) {
    return EnterScreenInput(raw, currency: "EUR");
    // TODO: find a better way
  }
  final match = matches.toList()[0];

  var currency = match.group(1);

  final amount = match.group(2);
  if (match.group(3) != null && match.group(3) != "") {
    currency = match.group(3);
  }
  final name = match.group(4)?.trim();

  if (currency != null) {
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

  return EnterScreenInput(raw, amount: value, currency: currency, name: name);
}
