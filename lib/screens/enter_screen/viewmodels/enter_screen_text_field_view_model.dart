import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/categories/utils/translate_category.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_data.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/models/suggestion_filters.dart';
import 'package:linum/screens/enter_screen/utils/example_string_builder.dart';
import 'package:linum/screens/enter_screen/utils/highlight_text_controller.dart';
import 'package:linum/screens/enter_screen/utils/string_from_existing_data.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/insert_suggestion.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/overlay/suggestion_list.dart';
import 'package:provider/provider.dart';


class EnterScreenTextFieldViewModel extends ChangeNotifier {

  late final BuildContext _context;
  late HighlightTextEditingController textController;
  late EnterScreenFormViewModel _formViewModel;
  late EntryType entryType;
  late StreamSubscription _streamSubscription;

  final GlobalKey textFieldKey = LabeledGlobalKey("text_field");

  EnterScreenTextFieldViewModel(
      BuildContext context, {
        String? prevControllerText,
  }) {
    _context = context;
    _formViewModel = context.read<EnterScreenFormViewModel>();

    final accountSettingsService = context.read<AccountSettingsService>();

    entryType = _formViewModel.entryType;
    print(entryType);

    final defaultCategory = entryType == EntryType.expense
        ? accountSettingsService.getExpenseEntryCategory()
        : accountSettingsService.getIncomeEntryCategory();

    textController = HighlightTextEditingController(
      exampleStringBuilder: ExampleStringBuilder(
        defaultAmount: 0.00,
        defaultCurrency: accountSettingsService.getStandardCurrency().name,
        defaultName: "Name",
        defaultCategory: translateCategory(defaultCategory),
        defaultDate: parsableDateMap[ParsableDate.today]!,
        defaultRepeatInfo: repeatConfigurations[RepeatInterval.none]!.label,
      ),
      parsingFilters: ParsingFilters(
        categoryFilter: (category) => category.entryType == entryType,
      ),
    );

    if (_formViewModel.withExistingData) {
      // Needs to be refactored a lot
      if (!_formViewModel.data.isParsed) {
        final text = StringBuilder()
            .useEnterScreenData(_formViewModel.data)
            .build();
        textController.text = text;
      }

    }

    if (prevControllerText != null) {
      textController.text = prevControllerText;
      print(textController.parsed);
    }

    textController.addListener(() {
      if (textController.parsed == null) {
        return;
      }
      _rebuildSuggestionList();
      _formViewModel.data = EnterScreenData.fromInput(
        textController.parsed!,
        notes: _formViewModel.data.notes,
      );
    });

    _streamSubscription = _formViewModel.stream.listen((data) {
      if (!data.isParsed) {
        textController.text = StringBuilder().useEnterScreenData(data).build();
      }
    });
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
            suggestions: textController.suggestions,
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
