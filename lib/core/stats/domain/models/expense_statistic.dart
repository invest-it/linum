class ExpenseStatisticsBuilder {
  num _upcoming = 0;
  num _current = 0;

  void addUpcoming(num upcoming) {
    _upcoming += upcoming;
  }
  void addCurrent(num current) {
    _current += current;
  }

  ExpenseStatistics build() {
    final record =  (upcoming: _upcoming, current: _current);
    _current = 0;
    _upcoming = 0;
    return record;
  }
}

typedef ExpenseStatistics = ({num upcoming, num current});
