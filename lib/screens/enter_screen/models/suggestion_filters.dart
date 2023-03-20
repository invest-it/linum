import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';

class SuggestionFilters {
  final bool Function(Category category)? categoryFilter;
  final bool Function(ParsableDate date)? dateFilter;
  final bool Function(RepeatInterval category)? repeatFilter;

  SuggestionFilters({
    this.categoryFilter,
    this.repeatFilter,
    this.dateFilter,
  });
}
