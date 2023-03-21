import 'package:linum/common/types/filter_function.dart';
import 'package:linum/common/types/sorter_function.dart';

class AlgorithmState {
  final Sorter<dynamic> sorter;
  final Filter<dynamic> filter;
  final DateTime shownMonth;

  AlgorithmState({
    required this.sorter,
    required this.filter,
    required this.shownMonth,
  });

  AlgorithmState copyWith({
    Sorter<dynamic>? sorter,
    Filter<dynamic>? filter,
    DateTime? shownMonth,
  }) {
    return AlgorithmState(
        sorter: sorter ?? this.sorter,
        filter: filter ?? this.filter,
        shownMonth: shownMonth ?? this.shownMonth,
    );
  }
}
