/// calculate next time step and decide for that if you need monthly steps or seconds as stepsize
DateTime calculateOneTimeStep(
  int stepsize,
  DateTime currentTime, {
  required bool monthly,
  int? dayOfTheMonth,
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
      dayOfTheMonth ?? currentTime.day,
    );
  }
  return newCurrentTime;
}

/// the counterpart to calculateOneTimeStep
DateTime calculateOneTimeStepBackwards(
  int stepsize,
  DateTime currentTime, {
  required bool monthly,
  int? dayOfTheMonth,
}) {
  late DateTime newCurrentTime;
  if (!monthly) {
    newCurrentTime = currentTime.subtract(
      Duration(
        seconds: stepsize,
      ),
    );
  } else {
    newCurrentTime = monthlyStepCalculator(
      currentTime.year,
      currentTime.month - stepsize,
      dayOfTheMonth ?? currentTime.day,
    );
  }
  return newCurrentTime;
}

/// avoid errors with 29th 30th and 31th
DateTime monthlyStepCalculator(int year, int month, int day) {
  final DateTime temp = DateTime(year, month, day);
  if ((temp.month % 12) == (month % 12)) {
    return temp;
  } else {
    return DateTime(temp.year, temp.month).subtract(const Duration(days: 1));
  }
}
