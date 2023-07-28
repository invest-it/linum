import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';

class SelectedOptions {
  final Currency? currency;
  final Category? category;
  final String? date;
  final RepeatConfiguration? repeatConfiguration;
  final String? notes;

  const SelectedOptions({
    this.currency,
    this.category,
    this.date,
    this.repeatConfiguration,
    this.notes,
  });


  SelectedOptions copyWith({
    Currency? currency,
    Category? category,
    String? date,
    RepeatConfiguration? repeatConfiguration,
    String? notes,
  }) {
    return SelectedOptions(
      currency: currency ?? this.currency,
      category: category ?? this.category,
      date: date ?? this.date,
      repeatConfiguration: repeatConfiguration ?? this.repeatConfiguration,
      notes: notes ?? this.notes,
    );
  }

  factory SelectedOptions.fromParsedData(StructuredParsedData parsedData) {
    return SelectedOptions(
      currency: parsedData.currency?.value,
      category: parsedData.category?.value,
      date: parsedData.date?.value,
      repeatConfiguration: parsedData.repeatInfo?.value,
    );
  }

  @override
  String toString() =>
      'SelectedOptions('
          'currency: $currency, '
          'category: $category, '
          'date: $date, '
          'repeatConfiguration: $repeatConfiguration, '
          'notes: $notes'
          ')';
}
