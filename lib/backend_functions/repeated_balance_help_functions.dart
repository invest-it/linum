bool isMonthly(Map<String, dynamic> singleRepeatedBalance) {
  return singleRepeatedBalance["repeatDurationType"] != null &&
      (singleRepeatedBalance["repeatDurationType"] as String).toUpperCase() ==
          "MONTHS";
}
