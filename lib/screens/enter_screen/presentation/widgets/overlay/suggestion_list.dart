import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/categories/core/presentation/category_service.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion_filters.dart';
import 'package:linum/screens/enter_screen/domain/suggesting/sub_suggestion_generator.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/overlay/suggestion_list_item.dart';
import 'package:provider/provider.dart';

void _onSelection(
  Suggestion suggestion,
  Suggestion? flagSuggestion,
) {}

class SuggestionList extends StatelessWidget {
  final List<Suggestion> suggestions;
  final double maxHeight;
  final ParsingFilters? parsingFilters;
  final void Function(
    Suggestion suggestion,
    Suggestion? flagSuggestion,
  ) onSelection;

  const SuggestionList({
    super.key,
    required this.suggestions,
    this.onSelection = _onSelection,
    this.maxHeight = 200,
    this.parsingFilters,
  });

  @override
  Widget build(BuildContext context) {
    final boxShadow = _getBoxShadow();

    if (suggestions.length == 1 && suggestions.first.isInputFlag) {
      return _SubSuggestionsList(
        boxShadow: boxShadow,
        flagSuggestion: suggestions.first,
        onSelection: onSelection,
        maxHeight: maxHeight,
        parsingFilters: parsingFilters,
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: Colors.white70,
        boxShadow: boxShadow,
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return SuggestionListItem(
              suggestion: suggestion,
              onSelection: onSelection,
          );
        },
      ),
    );
  }


  List<BoxShadow>? _getBoxShadow() {
    if (suggestions.isNotEmpty) {
      return [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 6,
          blurRadius: 6,
          offset: const Offset(0.5, 3), // changes position of shadow
        ),
      ];
    }
    return null;
  }
}


class _SubSuggestionsList extends StatelessWidget {
  final List<BoxShadow>? boxShadow;
  final Suggestion flagSuggestion;
  final double maxHeight;
  final ParsingFilters? parsingFilters;

  final void Function(
    Suggestion suggestion,
    Suggestion? parentSuggestion,
  ) onSelection;

  const _SubSuggestionsList({
    required this.flagSuggestion,
    this.onSelection = _onSelection,
    this.maxHeight = 200,
    this.boxShadow,
    this.parsingFilters,
  });

  @override
  Widget build(BuildContext context) {
    final subSuggestions = SubSuggestionsGenerator(
      categories: context.read<ICategoryService>().getSuggestableCategories(),
    ).generate(
      flagSuggestion.flag!,
      filters: parsingFilters,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: Colors.white70,
        boxShadow: boxShadow,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
            ),
            child: Text(
              flagSuggestion.display(tr),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: subSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = subSuggestions[index];
                return SuggestionListItem(
                  suggestion: suggestion,
                  parentSuggestion: flagSuggestion,
                  onSelection: (child, parent) {
                    onSelection(child, parent);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
