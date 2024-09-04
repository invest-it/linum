
import 'package:flutter_test/flutter_test.dart';

void expectSameMonth(DateTime? actual, DateTime? matcher){
  if (actual == null || matcher == null){
    expect(actual, matcher);
    return;
};
  expect(actual.month, matcher.month);
  expect(actual.year, matcher.year);
}
