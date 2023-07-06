import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';

class ParsingFilters {
  final Filter<Category>? categoryFilter;
  final Filter<ParsableDate>? dateFilter;
  final Filter<RepeatInterval>? repeatFilter;

  ParsingFilters({
    this.categoryFilter,
    this.repeatFilter,
    this.dateFilter,
  });
}
