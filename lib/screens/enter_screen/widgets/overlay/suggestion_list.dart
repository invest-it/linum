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
  final Map<String, Suggestion> suggestions;
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
    final boxShadow = suggestions.isNotEmpty
        ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 6,
              blurRadius: 6,
              offset: const Offset(0.5, 3), // changes position of shadow
            ),
          ]
        : null;

    if (suggestions.length == 1 &&
        suggestions.entries.first.value.isInputFlag) {
      final parentSuggestion = suggestions.entries.first.value;
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
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: getSubSuggestions(parentSuggestion.flag!)
                    .map((suggestion) => SuggestionListItem(
                          suggestion: suggestion,
                          parentSuggestion: parentSuggestion,
                          onSelection: (child, parent) {
                            onSelection(child, parent);
                          },
                        ),)
                    .toList(),
              ),
            )
          ],
        ),
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
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: suggestions.entries
            .map((entry) => SuggestionListItem(
                  suggestion: entry.value,
                  onSelection: onSelection,
                ),)
            .toList(),
      ),
    );
  }
}
