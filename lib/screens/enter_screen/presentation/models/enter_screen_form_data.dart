import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';
import 'package:linum/screens/enter_screen/domain/models/structured_parsed_data.dart';
import 'package:linum/screens/enter_screen/presentation/models/selected_options.dart';

class EnterScreenFormData {
  StructuredParsedData parsed;
  SelectedOptions options;

  EnterScreenFormData({
    required this.parsed,
    required this.options,
  });

  EnterScreenFormData copyWith({
    StructuredParsedData? parsed,
    SelectedOptions? options,
  }) {
    return EnterScreenFormData(
        parsed: parsed ?? this.parsed,
        options: options ?? this.options,
    );
  }

  EnterScreenFormData copyWithOptions({
    Currency? currency,
    Category? category,
    String? date,
    RepeatConfiguration? repeatConfiguration,
    String? notes,
  }) {
    return EnterScreenFormData(
        parsed: parsed,
        options: options.copyWith(
          currency: currency ?? options.currency,
          category: category ?? options.category,
          date: date ?? options.date,
          repeatConfiguration: repeatConfiguration ?? options.repeatConfiguration,
          notes: notes ?? options.notes,
        ),
    );
  }


  EnterScreenFormData removeCategoryAndCopy() {
    StructuredParsedData? parsedData;
    if (parsed.hasCategory) {
      parsedData = parsed;
      final parsedInput = parsedData.category!;
      String raw = parsedData.raw;

      if (parsedInput.indices.end > raw.length) {
        raw = raw.replaceRange(
            parsedInput.indices.start,
            parsedInput.indices.end,
            "",
        );
      }

      parsedData = StructuredParsedData(
        raw,
        amount: parsedData.amount,
        currency: parsedData.currency,
        name: parsedData.name,
        date: parsedData.date,
        repeatInfo: parsedData.repeatInfo,
      );
    }

    if (parsedData == null) {
      return this;
    }

    return EnterScreenFormData(
      parsed: parsedData,
      options: SelectedOptions.fromParsedData(parsedData),
    );
  }


  @override
  String toString() => 'EnterScreenFormData('
      'parsed: $parsed, '
      'options: $options'
      ')';
}
