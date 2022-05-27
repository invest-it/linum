//  Sort Functions - Helper Function to Sort Inputs by certain criteria
//
//  Author: SoTBurst
//  Co-Author: damattl
//  (Refactored)

import 'package:cloud_firestore/cloud_firestore.dart';

int amountLeastToMost(dynamic a, dynamic b) {
  return ((a as Map<String, dynamic>)["amount"] as num)
      .compareTo((b as Map<String, dynamic>)["amount"] as num);
}

int amountMostToLeast(dynamic b, dynamic a) {
  return ((a as Map<String, dynamic>)["amount"] as num)
      .compareTo((b as Map<String, dynamic>)["amount"] as num);
}

int categoryAlphabetically(dynamic a, dynamic b) {
  return ((a as Map<String, dynamic>)["category"] as String)
      .compareTo((b as Map<String, dynamic>)["category"] as String);
}

int categoryAlphabeticallyReversed(dynamic b, dynamic a) {
  return ((a as Map<String, dynamic>)["category"] as String)
      .compareTo((b as Map<String, dynamic>)["category"] as String);
}

int nameAlphabetically(dynamic a, dynamic b) {
  return ((a as Map<String, dynamic>)["name"] as String)
      .compareTo((b as Map<String, dynamic>)["name"] as String);
}

int nameAlphabeticallyReversed(dynamic b, dynamic a) {
  return ((a as Map<String, dynamic>)["name"] as String)
      .compareTo((b as Map<String, dynamic>)["name"] as String);
}

int timeNewToOld(dynamic a, dynamic b) {
  return ((b as Map<String, dynamic>)["time"] as Timestamp)
      .compareTo((a as Map<String, dynamic>)["time"] as Timestamp);
}

int timeOldToNew(dynamic b, dynamic a) {
  return ((a as Map<String, dynamic>)["time"] as Timestamp)
      .compareTo((b as Map<String, dynamic>)["time"] as Timestamp);
}
