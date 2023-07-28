import 'package:linum/screens/enter_screen/models/enter_screen_form_data.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/models/selected_options.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';

class DidChange {
  final bool category;
  final bool currency;
  final bool date;
  final bool repeatInfo;

  DidChange({
    this.category = false,
    this.currency = false,
    this.date = false,
    this.repeatInfo = false,
  });

  bool get changed => category || currency || repeatInfo || date;
}


class FormDataUpdater {
  final EnterScreenFormData oldData;
  final EnterScreenFormData newData;

  EnterScreenFormData? updatedData;

  late final DidChange _optionsChanged;

  FormDataUpdater({
    required this.oldData,
    required this.newData,
  }) {
    _optionsChanged = _detectOptionChanges(
        oldOptions: oldData.options,
        newOptions: newData.options,
    );
  }

  EnterScreenFormData update() {
    if (_optionsChanged.changed) {
      _handleChangedOptions();
    }

    // TODO: Carefull this might override previous changes
    if (oldData.parsed != newData.parsed) {
      updatedData ??= newData;
      updatedData = updatedData?.copyWith(
        options: SelectedOptions.fromParsedData(newData.parsed),
      );
    }

    if (updatedData == null) {
      return newData;
    }
    return updatedData!;
  }

  void _handleChangedOptions() {
    StructuredParsedData parsedData = newData.parsed;

    if (_optionsChanged.currency) {
      parsedData = _removeParsedCurrency(parsedData);
    }
    if (_optionsChanged.category) {
      parsedData = _removeParsedCategory(parsedData);
    }
    if (_optionsChanged.date) {
      parsedData = _removeParsedDate(parsedData);
    }
    if (_optionsChanged.repeatInfo) {
      parsedData = _removeParsedRepeatInfo(parsedData);
    }
    updatedData = newData.copyWith(
      parsed: parsedData,
    );
  }

  StructuredParsedData _removeParsedCurrency(
      StructuredParsedData parsedData,
  ) {
    final parsedInput = parsedData.currency;
    if (parsedInput == null) {
      return parsedData;
    }
    final raw = _replaceParsedInput(parsedInput, parsedData.raw);
    return StructuredParsedData(
      raw,
      amount: parsedData.amount,
      name: parsedData.name,
      category: parsedData.category,
      date: parsedData.date,
      repeatInfo: parsedData.repeatInfo,
    );
  }

  StructuredParsedData _removeParsedCategory(
      StructuredParsedData parsedData,
      ) {
    final parsedInput = parsedData.category;
    if (parsedInput == null) {
      return parsedData;
    }
    final raw = _replaceParsedInput(parsedInput, parsedData.raw);
    return StructuredParsedData(
      raw,
      amount: parsedData.amount,
      name: parsedData.name,
      currency: parsedData.currency,
      date: parsedData.date,
      repeatInfo: parsedData.repeatInfo,
    );
  }

  StructuredParsedData _removeParsedDate(
      StructuredParsedData parsedData,
      ) {
    final parsedInput = parsedData.date;
    if (parsedInput == null) {
      return parsedData;
    }
    final raw = _replaceParsedInput(parsedInput, parsedData.raw);
    return StructuredParsedData(
      raw,
      amount: parsedData.amount,
      name: parsedData.name,
      currency: parsedData.currency,
      category: parsedData.category,
      repeatInfo: parsedData.repeatInfo,
    );
  }

  StructuredParsedData _removeParsedRepeatInfo(
      StructuredParsedData parsedData,
  ) {
    final parsedInput = parsedData.repeatInfo;
    if (parsedInput == null) {
      return parsedData;
    }
    final raw = _replaceParsedInput(parsedInput, parsedData.raw);
    return StructuredParsedData(
      raw,
      amount: parsedData.amount,
      name: parsedData.name,
      currency: parsedData.currency,
      category: parsedData.category,
      date: parsedData.date,
    );
  }

  String _replaceParsedInput(ParsedInput parsedInput, String raw) {
    if (parsedInput.indices.end > raw.length) {
      return raw;
    }
    return raw.replaceRange(
      parsedInput.indices.start,
      parsedInput.indices.end,
      "",
    );
  }
}


DidChange _detectOptionChanges({
  required SelectedOptions oldOptions,
  required SelectedOptions newOptions,
}) {
  bool categoryChanged = false;
  bool currencyChanged = false;
  bool repeatConfigurationChanged = false;
  bool dateChanged = false;

  if (oldOptions.category != newOptions.category) {
    categoryChanged = true;
  }
  if (oldOptions.currency != newOptions.currency) {
    currencyChanged = true;
  }
  if (oldOptions.repeatConfiguration != newOptions.repeatConfiguration) {
    repeatConfigurationChanged = true;
  }
  if (oldOptions.date != newOptions.date) {
    dateChanged = true;
  }

  return DidChange(
    category: categoryChanged,
    currency: currencyChanged,
    date: dateChanged,
    repeatInfo: repeatConfigurationChanged,
  );
}
