/// calculate next time step and decide for that if you need monthly steps or seconds as stepsize
DateTime calculateOneTimeStep(
  int stepsize,
  DateTime currentTime, {
  required bool monthly,
  int dayOfTheMonth = 1,
}) {
  late DateTime newCurrentTime;
  if (!monthly) {
    newCurrentTime = currentTime.add(
      Duration(
        seconds: stepsize,
      ),
    );
  } else {
    newCurrentTime = monthlyStepCalculator(
      currentTime.year,
      currentTime.month + stepsize,
      dayOfTheMonth,
    );
  }
  return newCurrentTime;
}

/// avoid errors with 29th 30th and 31th
DateTime monthlyStepCalculator(int year, int month, int day) {
  final DateTime temp = DateTime(year, month, day);
  if (temp.month == month || month == 13) {
    return temp;
  } else {
    return DateTime(temp.year, temp.month).subtract(const Duration(days: 1));
  }
}
