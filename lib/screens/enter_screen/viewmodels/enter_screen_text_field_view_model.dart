import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/utils/translate_category.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/screens/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/models/suggestion_filters.dart';
import 'package:linum/screens/enter_screen/utils/example_string_builder.dart';
import 'package:linum/screens/enter_screen/utils/highlight_text_controller.dart';
import 'package:linum/screens/enter_screen/utils/parsing/context_extensions.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/insert_suggestion.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/overlay/suggestion_list.dart';
import 'package:provider/provider.dart';


class EnterScreenTextFieldViewModel extends ChangeNotifier {

  late BuildContext _context;
  late HighlightTextEditingController _textController;
  late EnterScreenFormViewModel _formViewModel;
  late EntryType _entryType;
  late StreamSubscription _streamSubscription;

  HighlightTextEditingController get textController => _textController;

  final GlobalKey textFieldKey = LabeledGlobalKey("text_field");

  EnterScreenTextFieldViewModel(BuildContext context) {
    _context = context;
    _formViewModel = context.read<EnterScreenFormViewModel>();

    _entryType = context.getEntryType();
    _setupTextController();

    _streamSubscription = _formViewModel.stream.listen((data) {
      if (data.parsed.raw != textController.text) {
        textController.text = data.parsed.raw;
      }

    });
  }

  void _setupTextController() {
    final currencySettingsService = _context.read<ICurrencySettingsService>();
    final categorySettingsService = _context.read<ICategorySettingsService>();

    final defaultCategory = _entryType == EntryType.expense
        ? categorySettingsService.getExpenseEntryCategory()
        : categorySettingsService.getIncomeEntryCategory();

    _textController = HighlightTextEditingController(
      exampleStringBuilder: ExampleStringBuilder(
        defaultAmount: 0.00,
        defaultCurrency: currencySettingsService.getStandardCurrency().name,
        defaultName: "Name",
        defaultCategory: translateCategory(defaultCategory),
        defaultDate: parsableDateMap[ParsableDate.today]!,
        defaultRepeatInfo: repeatConfigurations[RepeatInterval.none]!.label,
      ),
      parsingFilters: ParsingFilters(
        categoryFilter: (category) => category.entryType == _entryType,
      ),
    );

    textController.text = _formViewModel.data.parsed.raw;

    // TODO Get rid of this

    textController.addListener(() {
      final parsedData = textController.parsed;
      if (parsedData == null) {
        return;
      }
      _rebuildSuggestionList();
      _formViewModel.data = _formViewModel.data.copyWith(
        parsed: parsedData,
      );
    });
  }

  void handleUpdate(BuildContext context) {
    final newEntryType = context.getEntryType();
    if (newEntryType != _entryType) {
      _context = context;
      _formViewModel = context.read<EnterScreenFormViewModel>();
      _entryType = newEntryType;
      textController.dispose();
      _setupTextController();
      notifyListeners();
    }
  }


  void _rebuildSuggestionList() {
    final keyContext = textFieldKey.currentContext;
    if (keyContext == null) {
      return;
    }
    final renderBox = keyContext.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    final position = renderBox?.localToGlobal(Offset.zero);
    if (size == null || position == null) {
      return;
    }

    _formViewModel.setOverlayEntry(_overlayEntryBuilder(_context, size, position));
    Overlay.of(_context).insert(_formViewModel.currentOverlay!);
  }

  OverlayEntry _overlayEntryBuilder(
      BuildContext context,
      Size size,
      Offset position,
      ) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        bottom: useScreenHeight(context) - position.dy,
        left: position.dx,
        width: size.width,
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: SuggestionList(
            suggestions: textController.suggestions.values.toList(),
            onSelection: (child, parent) {
              _onSuggestionSelection(child, parent);
            },
          ),
        ),
      );
    },);
  }

  void _onSuggestionSelection(
      Suggestion suggestion,
      Suggestion? parentSuggestion,
      ) {
    final value = insertSuggestion(
      suggestion: suggestion,
      oldText: textController.text,
      oldCursor: textController.selection.base.offset,
      parentSuggestion: parentSuggestion,
    );
    textController.value = value;
  }



  @override
  void dispose() {
    textController.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }
}
