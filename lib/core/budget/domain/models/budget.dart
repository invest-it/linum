import 'package:linum/common/interfaces/mappable.dart';
import 'package:linum/core/budget/domain/models/budget_cap.dart';

class Budget implements IMappable<Budget> {
  final BudgetCap cap;
  final List<String> categories;
  final DateTime start;
  final DateTime? end;

  Budget({
    required this.cap,
    required this.categories,
    required this.start,
    this.end,
  }): assert(categories.isNotEmpty);

  @override
  Map<String, dynamic> toMap() {
    return {
      "cap": cap.toMap(),
      "categories": categories,
      "start": start.toIso8601String(),
      "end": end?.toIso8601String(),
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    final end = map["end"] as String?;

    return Budget(
      cap: BudgetCap.fromMap(map["cap"] as Map<String, dynamic>),
      categories: map["categories"] as List<String>,
      start: DateTime.parse(map["start"] as String),
      end: end != null ? DateTime.parse(end) : null,
    );
  }
}

class BudgetFactory implements IMappableFactory<Budget> {
  @override
  Budget fromMap(Map<String, dynamic> map) {
    return Budget.fromMap(map);
  }
}
