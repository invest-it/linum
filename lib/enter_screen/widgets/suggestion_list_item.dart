import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/enter_screen/models/suggestion.dart';

class SuggestionListItem extends StatelessWidget {
  final Suggestion suggestion;
  final Suggestion? parentSuggestion;
  final void Function(
    Suggestion suggestion,
    Suggestion? parentSuggestion,
  ) onSelection;
  const SuggestionListItem({
    super.key,
    required this.suggestion,
    required this.onSelection,
    this.parentSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelection(suggestion, parentSuggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 10),
        child: Text(
          suggestion.display(tr),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
