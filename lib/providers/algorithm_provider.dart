import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// gives sort algorithm (later it will probably also have filter algorithm) and
/// all algorithm will have an active version instead of being static
/// so it is possible to have dynamic sort and filter algorithm
class AlgorithmProvider extends ChangeNotifier {
  static int amountLeastToMost(dynamic a, dynamic b) {
    return a["amount"].compareTo(b["amount"]);
  }

  static int amountMostToLeast(dynamic b, dynamic a) {
    return a["amount"].compareTo(b["amount"]);
  }

  static int categoryAlphabetically(dynamic a, dynamic b) {
    return a["category"].compareTo(b["category"]);
  }

  static int categoryAlphabeticallyReversed(dynamic b, dynamic a) {
    return a["category"].compareTo(b["category"]);
  }

  static int nameAlphabetically(dynamic a, dynamic b) {
    return a["name"].compareTo(b["name"]);
  }

  static int nameAlphabeticallyReversed(dynamic b, dynamic a) {
    return a["name"].compareTo(b["name"]);
  }

  static int timeNewToOld(dynamic a, dynamic b) {
    return a["time"].compareTo(b["time"]);
  }

  static int timeOldToNew(dynamic b, dynamic a) {
    return a["time"].compareTo(b["time"]);
  }

  static bool noFilter(dynamic a) {
    return false;
  }

  static Function newerThan(Timestamp timestamp) {
    return (dynamic a) => (a.compareTo(timestamp) >= 0);
  }

  static Function olderThan(Timestamp timestamp) {
    return (dynamic a) => (a.compareTo(timestamp) <= 0);
  }

  static Function inBetween(Timestamp timestamp1, Timestamp timestamp2) {
    return (dynamic a) =>
        (a.compareTo(timestamp1) <= 0) && (a.compareTo(timestamp2) >= 0);
  }

  static Function costsMoreThan(num amount) {
    return (dynamic a) => (a.compareTo(amount) >= 0);
  }

  static Function costsLessThan(num amount) {
    return (dynamic a) => (a.compareTo(amount) <= 0);
  }
}
