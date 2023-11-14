import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/core/categories/core/utils/translate_category.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/screens/enter_screen/domain/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/domain/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion_filters.dart';
import 'package:linum/screens/enter_screen/presentation/utils/context_extensions.dart';
import 'package:linum/screens/enter_screen/presentation/utils/example_string_builder.dart';
import 'package:linum/screens/enter_screen/presentation/utils/highlight_text_controller.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/overlay/suggestion_list.dart';
import 'package:provider/provider.dart';


class EnterScreenTextFieldViewModel extends ChangeNotifier {

  late BuildContext _context;
  late HighlightTextEditingController _textController;
  late EnterScreenFormViewModel _formViewModel;
  late EntryType _entryType;
  late StreamSubscription _streamSubscription;

  final ITranslator _translator;

  HighlightTextEditingController get textController => _textController;

  final GlobalKey textFieldKey = LabeledGlobalKey("text_field");

  EnterScreenTextFieldViewModel(BuildContext context, this._translator) {
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
        translator: _translator,
      ),
      translator: _translator,
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
    final textFieldRef = textFieldKey.currentContext;
    final cursorRef = textController.cursorRefKey.currentContext;

    if (textFieldRef == null || cursorRef == null) {
      return;
    }
    final textFieldRenderBox = textFieldRef.findRenderObject() as RenderBox?;
    final textFieldSize = textFieldRenderBox?.size;
    final textFieldPosition = textFieldRenderBox?.localToGlobal(Offset.zero);

    final cursorRenderBox = cursorRef.findRenderObject() as RenderBox?;
    final cursorSize = cursorRenderBox?.size;
    final cursorPosition = cursorRenderBox?.localToGlobal(Offset.zero);

    if (textFieldSize == null
        || textFieldPosition == null
        || cursorSize == null
        || cursorPosition == null
    ) {
      return;
    }

    _formViewModel.setOverlayEntry(_overlayEntryBuilder(
        _context,
        textFieldSize: textFieldSize,
        textFieldPosition: textFieldPosition,
        cursorPosition: cursorPosition,
        cursorSize: cursorSize,
    ),);
    Overlay.of(_context).insert(_formViewModel.currentOverlay!);
  }

  OverlayEntry _overlayEntryBuilder(
      BuildContext context,
  {
    required Size textFieldSize,
    required Offset textFieldPosition,
    required Size cursorSize,
    required Offset cursorPosition,
  }) {
    return OverlayEntry(builder: (context) {
      final maxHeight = (useScreenHeight(context)
          - cursorPosition.dy 
          - useKeyBoardHeight(context)
          - 6*cursorSize.height).abs();
      
      return Positioned(
        top: cursorPosition.dy + cursorSize.height + 3.0,
        // bottom: useScreenHeight(context) - position.dy - 2*size.height,
        // bottom: useScreenHeight(context) - position.dy,
        left: textFieldPosition.dx,
        width: textFieldSize.width,

        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: SuggestionList(
            maxHeight: maxHeight,
            suggestions: textController.suggestions,
            onSelection: (tag, flag) {
              textController.useSuggestion(tag, flag);
            },
          ),
        ),
      );
    },);
  }




  @override
  void dispose() {
    textController.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }
}
