import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/get_sub_suggestions.dart';
import 'package:linum/screens/enter_screen/widgets/overlay/suggestion_list_item.dart';

void _onSelection(
  Suggestion suggestion,
  Suggestion? parentSuggestion,
) {}

class SuggestionList extends StatelessWidget {
  final List<Suggestion> suggestions;
  final double maxHeight;
  final void Function(
    Suggestion suggestion,
    Suggestion? parentSuggestion,
  ) onSelection;

  const SuggestionList({
    super.key,
    required this.suggestions,
    this.onSelection = _onSelection,
    this.maxHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    final boxShadow = _getBoxShadow();

    if (suggestions.length == 1 && suggestions.first.isInputFlag) {
      return _SubSuggestionsList(
        boxShadow: boxShadow,
        parentSuggestion: suggestions.first,
        onSelection: onSelection,
        maxHeight: maxHeight,
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
  final Suggestion parentSuggestion;
  final double maxHeight;
  final void Function(
    Suggestion suggestion,
    Suggestion? parentSuggestion,
  ) onSelection;

  const _SubSuggestionsList({
    required this.parentSuggestion,
    this.onSelection = _onSelection,
    this.maxHeight = 200,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final subSuggestions = getSubSuggestions(parentSuggestion.flag!);

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
              parentSuggestion.display(tr),
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
                  parentSuggestion: parentSuggestion,
                  onSelection: (child, parent) {
                    onSelection(child, parent);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
