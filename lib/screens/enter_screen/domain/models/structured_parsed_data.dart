import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';
import 'package:linum/screens/enter_screen/domain/enums/input_type.dart';
import 'package:linum/screens/enter_screen/domain/models/parsed_input.dart';

typedef TextIndices = ({int start, int end});


class StructuredParsedData {
  final String raw;
  final ParsedInput<double>? amount;
  final ParsedInput<Currency>? currency;
  final ParsedInput<String>? name;
  final ParsedInput<Category>? category;
  final ParsedInput<String>? date;
  final ParsedInput<RepeatConfiguration>? repeatInfo;

  StructuredParsedData(
    this.raw, {
      this.amount,
      this.name,
      this.currency,
      this.category,
      this.date,
      this.repeatInfo,
  });



  factory StructuredParsedData.fromParsedInputs(List<ParsedInput> parsedInputs, String raw) {
    ParsedInput<double>? amount;
    ParsedInput<Currency>? currency;
    ParsedInput<String>? name;
    ParsedInput<Category>? category;
    ParsedInput<String>? date;
    ParsedInput<RepeatConfiguration>? repeatInfo;

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
          category = _castOrNull<Category>(parsed);
          continue;
        case InputType.date:
          date = _castOrNull<String>(parsed);
          continue;
        case InputType.repeatInfo:
          repeatInfo = _castOrNull<RepeatConfiguration>(parsed);
          continue;
      }
    }

    return StructuredParsedData(
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


  StructuredParsedData copyWith({
    String? raw,
    ParsedInput<double>? amount,
    ParsedInput<Currency>? currency,
    ParsedInput<String>? name,
    ParsedInput<Category>? category,
    ParsedInput<String>? date,
    ParsedInput<RepeatConfiguration>? repeatInfo,
  }) {
    return StructuredParsedData(
      raw ?? this.raw,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      name: name ?? this.name,
      category: category ?? this.category,
      date: date ?? this.date,
      repeatInfo: repeatInfo ?? this.repeatInfo,
    );
  }

  @override
  String toString() {
    return 'StructuredParsedData('
        'raw: $raw, '
        'amount: $amount, '
        'currency: $currency, '
        'name: $name, '
        'category: $category, '
        'date: $date, '
        'repeatInfo: $repeatInfo'
        ')';
  }



  @override
  bool operator ==(Object other) {
    if (other is StructuredParsedData) {
      return raw == other.raw &&
          amount == other.amount &&
          currency == other.currency &&
          name == other.name &&
          category == other.category &&
          date == other.date &&
          repeatInfo == other.repeatInfo;
    }
    return false;
  }

  @override
  int get hashCode {
    return raw.hashCode ^
        amount.hashCode ^
        currency.hashCode ^
        name.hashCode ^
        category.hashCode ^
        date.hashCode ^
        repeatInfo.hashCode;
  }

}

ParsedInput<T>? _castOrNull<T>(ParsedInput parsedInput) {
  if (parsedInput is ParsedInput<T>) {

    return parsedInput;
  }
  return null;
}
