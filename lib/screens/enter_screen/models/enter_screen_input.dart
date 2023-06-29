import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';

typedef TextIndices = ({int start, int end});


class EnterScreenInput {
  final String raw;
  final ParsedInput<double>? amount;
  final ParsedInput<Currency>? currency;
  final ParsedInput<String>? name;
  final ParsedInput<String>? category;
  final ParsedInput<String>? date;
  final ParsedInput<String>? repeatInfo;

  EnterScreenInput(
    this.raw, {
      this.amount,
      this.name,
      this.currency,
      this.category,
      this.date,
      this.repeatInfo,
  });




  factory EnterScreenInput.fromParsedInputs(List<ParsedInput> parsedInputs, String raw) {
    ParsedInput<double>? amount;
    ParsedInput<Currency>? currency;
    ParsedInput<String>? name;
    ParsedInput<String>? category;
    ParsedInput<String>? date;
    ParsedInput<String>? repeatInfo;

    for (final parsed in parsedInputs) {
      switch(parsed.type) {
        case InputType.amount:
          amount = _castOrNull<double>(parsed);
          continue;
        case InputType.currency:
          currency = _castOrNull<Currency>(parsed);
          continue;
        case InputType.name:
          name = _castOrNull<String>(parsed);
          continue;
        case InputType.category:
          category = _castOrNull<String>(parsed);
          continue;
        case InputType.date:
          date = _castOrNull<String>(parsed);
          continue;
        case InputType.repeatInfo:
          repeatInfo = _castOrNull<String>(parsed);
          continue;
      }
    }

    return EnterScreenInput(
      raw,
      amount: amount,
      currency: currency,
      name: name,
      category: category,
      date: date,
      repeatInfo: repeatInfo,
    );
  }

  bool get hasAmount => amount != null;
  bool get hasCurrency => currency != null;
  bool get hasName => name != null;
  bool get hasCategory => category != null;
  bool get hasDate => date != null;
  bool get hasRepeatInfo => repeatInfo != null;


  List<ParsedInput> toList() {
    final List<ParsedInput> list = [];
    if (hasAmount) {
      list.add(amount!);
    }
    if (hasCurrency) {
      list.add(currency!);
    }
    if (hasName) {
      list.add(name!);
    }
    if (hasRepeatInfo) {
      list.add(repeatInfo!);
    }
    if (hasCategory) {
      list.add(category!);
    }
    if (hasDate) {
      list.add(date!);
    }
    return list;
  }

  @override
  String toString() {
    return 'EnterScreenInput('
        'raw: $raw, '
        'amount: $amount, '
        'currency: $currency, '
        'name: $name, '
        'category: $category, '
        'date: $date, '
        'repeatInfo: $repeatInfo'
        ')';
  }
}


ParsedInput<T>? _castOrNull<T>(ParsedInput parsedInput) {
  if (parsedInput is ParsedInput<T>) {

    return parsedInput;
  }
  return null;
}
