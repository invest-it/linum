// ignore_for_file: unused_element
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/repeat_duration_type_enum.dart';
import 'package:linum/models/repeatable_change_type.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/abstract/abstract_statistic_panel.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// Provides the balance data from the database using the uid.
class BalanceDataProvider extends ChangeNotifier {
  /// _balance is the documentReference to get the balance data from the database. It will be null if the constructor isnt ready yet
  DocumentReference<Map<String, dynamic>>? _balance;

  /// The uid of the user
  late String _uid;

  late AlgorithmProvider _algorithmProvider;

  num _dontDispose = 0;

  static const Duration futureDuration = Duration(days: 30 * 3);

  /// Creates the BalanceDataProvider. Inparticular it sets [_balance] correctly
  BalanceDataProvider(BuildContext context) {
    _uid = Provider.of<AuthenticationService>(context, listen: false).uid;
    _algorithmProvider = Provider.of<AlgorithmProvider>(context, listen: false);
    asynConstructor();
  }

  /// Async part of the constructor (so notifyListeners will be used after loading)
  Future<void> asynConstructor() async {
    if (_uid == "") {
      return;
    }
    final DocumentSnapshot<Map<String, dynamic>> documentToUser =
        await FirebaseFirestore.instance
            .collection('balance')
            .doc("documentToUser")
            .get();
    if (documentToUser.exists) {
      List<dynamic>? docs;
      try {
        docs = documentToUser.get(_uid) as List<dynamic>?;
      } catch (e) {
        docs = await _createDoc();
      }
      if (docs == null) {
        //docs = await _createDoc();
        dev.log("error getting doc id");
        return;
      }
      if (docs.isEmpty) {
        docs = await _createDoc();
      }

      // Future support multiple docs per user
      _balance = FirebaseFirestore.instance
          .collection('balance')
          .doc(docs[0] as String);
      notifyListeners();
    } else {
      dev.log("no data found in documentToUser");
    }
  }

  Future<List<dynamic>> _createDoc() async {
    dev.log("creating document");
    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('balance')
        .doc("documentToUser")
        .get();
    final Map<String, dynamic>? docData = doc.data();
    Map<String, dynamic> docDataNullSafe = {};
    if (docData != null) {
      docDataNullSafe = docData;
    }

    final DocumentReference<Map<String, dynamic>> ref =
        await FirebaseFirestore.instance.collection('balance').add({
      "balanceData": [],
      "repeatedBalance": [],
      "settings": {},
    });

    await FirebaseFirestore.instance
        .collection('balance')
        .doc("documentToUser")
        .set(
          docDataNullSafe
            ..addAll({
              _uid: [ref.id]
            }),
        );
    return [ref.id];
  }

  void updateAuth(AuthenticationService? auth) {
    if (auth != null && auth.uid != _uid) {
      _uid = auth.uid;
      asynConstructor();
    }
  }

  void updateAlgorithmProvider(AlgorithmProvider? algorithm) {
    if (algorithm != null &&
        (_algorithmProvider != algorithm ||
            _algorithmProvider.balanceNeedsNotice)) {
      _algorithmProvider = algorithm;
      _algorithmProvider.balanceDataNotice();
      notifyListeners();
    }
  }

  /// Get the document-datastream. Maybe in the future it might be a public function
  Stream<DocumentSnapshot<Map<String, dynamic>>>? get _dataStream {
    return _balance?.snapshots();
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillListViewWithData(
    BalanceDataListView blistview, {
    required BuildContext context,
  }) {
    return StreamBuilder(
      stream: _dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          blistview.setBalanceData(
            [
              {"Error": "snapshot.data == null"}
            ],
            context: context,
          );
          return blistview.listview;
        } else {
          final List<List<Map<String, dynamic>>> arrayData =
              prepareData(snapshot);
          final List<Map<String, dynamic>> balanceData = arrayData[0];

          // Future there could be an sort algorithm provider
          // (and possibly also a filter algorithm provided)
          balanceData.sort(_algorithmProvider.currentSorter);
          blistview.setBalanceData(balanceData, context: context);
          return blistview.listview;
        }
      },
    );
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillStatisticPanelWithData(
    AbstractStatisticPanel statisticPanel,
  ) {
    return StreamBuilder(
      stream: _dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          statisticPanel.addStatisticData(null);
          return statisticPanel.returnWidget;
        } else {
          final List<List<Map<String, dynamic>>> arrayData =
              prepareData(snapshot);
          final List<Map<String, dynamic>> balanceData = arrayData[0];
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(balanceData);
          statisticPanel.addStatisticData(statisticsCalculations);
          return statisticPanel.returnWidget;
        }
      },
    );
  }

  List<List<Map<String, dynamic>>> prepareData(
    AsyncSnapshot<dynamic> snapshot,
  ) {
    final Map<String, dynamic>? data =
        (snapshot.data as DocumentSnapshot<Map<String, dynamic>>).data();
    final List<dynamic> balanceDataDynamic =
        data!["balanceData"] as List<dynamic>;
    final List<Map<String, dynamic>> balanceData = <Map<String, dynamic>>[];
    for (final singleBalance in balanceDataDynamic) {
      if ((singleBalance as Map<String, dynamic>)["repeatId"] == null) {
        balanceData.add(singleBalance);
      }
    }

    final List<dynamic> repeatedBalanceDynamic =
        data["repeatedBalance"] as List<dynamic>;
    final List<Map<String, dynamic>> repeatedBalance = <Map<String, dynamic>>[];
    for (final singleRepeatable in repeatedBalanceDynamic) {
      repeatedBalance.add(singleRepeatable as Map<String, dynamic>);
    }

    addAllRepeatablesToBalanceDataLocally(repeatedBalance, balanceData);

    balanceData.removeWhere(_algorithmProvider.currentFilter);
    return [balanceData, repeatedBalance];
  }

  /// add a single Balance and upload it
  Future<bool> addSingleBalance(SingleBalanceData singleBalance) async {
    if (_balance == null) {
      dev.log("_balance is null");
      return false;
    }
    if (singleBalance.category == "" || singleBalance.currency == "") {
      return false;
    }
    final Map<String, dynamic> singleBalanceMap = {
      "amount": singleBalance.amount,
      "category": singleBalance.category,
      "currency": singleBalance.currency,
      "name": singleBalance.name,
      "time": singleBalance.time,
      "id": const Uuid().v4(),
    };
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? dataAsMap = snapshot.data();
    (dataAsMap!["balanceData"] as List<dynamic>).add(singleBalanceMap);
    await _balance!.set(dataAsMap);
    return true;
  }

  /// remove a single Balance and upload it (identified using id)
  Future<bool> removeSingleBalanceUsingId(String id) async {
    if (_balance == null) {
      dev.log("_balance is null");
      return false;
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    final int dataLength = (data!["balanceData"] as List<dynamic>).length;
    (data["balanceData"] as List<dynamic>).removeWhere((value) {
      return (value as Map<String, dynamic>)["id"] == id ||
          value["id"] == null ||
          value["repeatId"] != null; // Auto delete trash data
    });
    if (dataLength > (data["balanceData"] as List<dynamic>).length) {
      await _balance!.set(data);
      return true;
    }
    return false;
  }

  Future<bool> removeSingleBalance(SingleBalanceData singleBalance) {
    return removeSingleBalanceUsingId(singleBalance.id);
  }

  /// update a single Balance and upload it (identified using the name and time)
  Future<bool> updateSingleBalance({
    required String id,
    num? amount,
    String? category,
    String? currency,
    String? name,
    Timestamp? time,
  }) async {
    if (_balance == null) {
      dev.log("_balance is null");
      return false;
    }
    if (id == "") {
      dev.log("no id provided");
      return false;
    }
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    for (final value in data!["balanceData"] as List<dynamic>) {
      if ((value as Map<String, dynamic>)["id"] == id) {
        value["amount"] = amount ?? value["amount"];
        value["category"] = category ?? value["category"];
        value["currency"] = currency ?? value["currency"];
        value["name"] = name ?? value["name"];
        value["time"] = time ?? value["time"];
      }
    }
    await _balance!.update(data);

    return true;
  }

  void dontDisposeOneTime() {
    _dontDispose++;
  }

  @override
  void dispose() {
    if (_dontDispose-- == 0) {
      super.dispose();
    }
  }

  // .
  Future<bool> addRepeatedBalance(
    RepeatBalanceData repeatBalanceData,
  ) async {
    if (_balance == null) {
      dev.log("_balance is null");
      return false;
    }
    if (repeatBalanceData.category == "" || repeatBalanceData.currency == "") {
      return false;
    }
    final Map<String, dynamic> singleRepeatedBalance = {
      "amount": repeatBalanceData.amount,
      "category": repeatBalanceData.category,
      "currency": repeatBalanceData.currency,
      "name": repeatBalanceData.name,
      "initialTime": repeatBalanceData.initialTime,
      "repeatDuration": repeatBalanceData.repeatDuration,
      "repeatDurationType":
          repeatBalanceData.repeatDurationType.toString().substring(19),
      "endTime": repeatBalanceData.endTime,
      "id": const Uuid().v4(),
    };
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    (data!["repeatedBalance"] as List<dynamic>).add(singleRepeatedBalance);
    await _balance!.set(data);
    return true;
  }

  // specify time if changeType != RepeatableChangeType.all
  // resetEndTime, endTime are no available for allBefore
  Future<bool> updateRepeatedBalance({
    required String id,
    required RepeatableChangeType changeType,
    num? amount,
    String? category,
    String? currency,
    String? name,
    Timestamp? initialTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    Timestamp? endTime,
    bool? resetEndTime,
    Timestamp? time,
  }) async {
    if (_balance == null) {
      dev.log("_balance is null");
      return false;
    }
    if (changeType != RepeatableChangeType.all && time == null) {
      dev.log("specify time if changeType != RepeatableChangeType.all");
      return false;
    }
    bool isEdited = false;
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    if (data == null) {
      return false;
    }
    switch (changeType) {
      case RepeatableChangeType.all:
        for (final singleRepeatedBalance
            in data["repeatedBalance"] as List<dynamic>) {
          singleRepeatedBalance as Map<String, dynamic>;
          if (!isEdited && (singleRepeatedBalance["id"] == id)) {
            if (amount != null && amount != singleRepeatedBalance["amount"]) {
              singleRepeatedBalance["amount"] = amount;
              isEdited = true;
            }
            if (category != null &&
                category != singleRepeatedBalance["category"]) {
              singleRepeatedBalance["category"] = category;
              isEdited = true;
            }
            if (currency != null &&
                currency != singleRepeatedBalance["currency"]) {
              singleRepeatedBalance["currency"] = currency;
              isEdited = true;
            }
            if (name != null && name != singleRepeatedBalance["name"]) {
              singleRepeatedBalance["name"] = name;
              isEdited = true;
            }
            if (initialTime != null &&
                initialTime != singleRepeatedBalance["initialTime"]) {
              singleRepeatedBalance["initialTime"] = initialTime;
              isEdited = true;
            }
            if (repeatDuration != null &&
                repeatDuration != singleRepeatedBalance["repeatDuration"]) {
              singleRepeatedBalance["repeatDuration"] = repeatDuration;
              isEdited = true;
            }
            if (repeatDurationType != null &&
                repeatDurationType !=
                    EnumToString.fromString<RepeatDurationType>(
                      RepeatDurationType.values,
                      singleRepeatedBalance["repeatDurationType"] as String,
                    )) {
              singleRepeatedBalance["repeatDuration"] =
                  repeatDurationType.toString().substring(19);
              isEdited = true;
            }
            if (endTime != null &&
                endTime != singleRepeatedBalance["endTime"]) {
              singleRepeatedBalance["endTime"] = endTime;
              isEdited = true;
            }
            if (resetEndTime != null && resetEndTime) {
              singleRepeatedBalance["endTime"] = null;
              isEdited = true;
            }
            if (initialTime != null ||
                repeatDuration != null ||
                repeatDurationType != null) {
              // FUTURE lazy approach. might think of something clever in the future
              // (what if repeat duration changes. single repeatable changes change time or not? use the nth? complicated...)
              singleRepeatedBalance.remove("changed");
            }
            if (isEdited && singleRepeatedBalance["changed"] != null) {
              (singleRepeatedBalance["changed"] as Map<String, dynamic>)
                  .forEach((key, value) {
                if (value != null) {
                  if (amount != null) {
                    (value as Map<String, dynamic>).remove("amount");
                  }
                  if (category != null) {
                    (value as Map<String, dynamic>).remove("category");
                  }
                  if (currency != null) {
                    (value as Map<String, dynamic>).remove("currency");
                  }
                  if (name != null) {
                    (value as Map<String, dynamic>).remove("name");
                  }
                  // dont need initialTime
                  // dont need repeatDuration
                  // dont need repeatDurationType
                  // dont need endTime
                  // dont need resetEndTime,
                }
              });
            }
            break;
          }
        }
        break;
      case RepeatableChangeType.thisAndAllBefore:
        Map<String, dynamic>? newRepeatedBalance;
        for (final oldRepeatedBalance
            in data["repeatedBalance"] as List<dynamic>) {
          oldRepeatedBalance as Map<String, dynamic>;
          if (oldRepeatedBalance["id"] == id) {
            newRepeatedBalance = oldRepeatedBalance.map((key, value) {
              return MapEntry(key, value);
            });
            newRepeatedBalance["id"] = const Uuid().v4();
            if ((oldRepeatedBalance["repeatDurationType"] as String)
                    .toUpperCase() ==
                "MONTHS") {
              oldRepeatedBalance["initialTime"] = Timestamp.fromDate(
                DateTime(
                  time!.toDate().year,
                  time.toDate().month +
                      (oldRepeatedBalance["repeatDuration"] as int),
                  time.toDate().day,
                ),
              );
            } else {
              oldRepeatedBalance["initialTime"] = Timestamp.fromDate(
                time!.toDate().add(
                      Duration(
                        seconds: oldRepeatedBalance["repeatDuration"] as int,
                      ),
                    ),
              );
            }
            final Map<String, dynamic> changes = <String, dynamic>{
              "amount": amount,
              "category": category,
              "currency": currency,
              "name": name,
              "initialTime": initialTime,
              "repeatDuration": repeatDuration,
              "repeatDurationType": repeatDurationType,
              "endTime": time,
            };
            changes.removeWhere((_, value) => value == null);
            newRepeatedBalance.addAll(changes);

            removeUnusedChangedAttributes(newRepeatedBalance);
            removeUnusedChangedAttributes(oldRepeatedBalance);

            isEdited = true;
          }
        }
        (data["repeatedBalance"] as List<dynamic>).add(newRepeatedBalance);

        break;
      case RepeatableChangeType.thisAndAllAfter:
        Map<String, dynamic>? newRepeatedBalance;
        for (final oldRepeatedBalance
            in data["repeatedBalance"] as List<dynamic>) {
          oldRepeatedBalance as Map<String, dynamic>;
          if (oldRepeatedBalance["id"] == id) {
            newRepeatedBalance = oldRepeatedBalance.map((key, value) {
              return MapEntry(key, value);
            });
            newRepeatedBalance["id"] = const Uuid().v4();
            if ((oldRepeatedBalance["repeatDurationType"] as String)
                    .toUpperCase() ==
                "MONTHS") {
              oldRepeatedBalance["endTime"] = Timestamp.fromDate(
                DateTime(
                  time!.toDate().year,
                  time.toDate().month -
                      (oldRepeatedBalance["repeatDuration"] as int),
                  time.toDate().day,
                ),
              );
            } else {
              oldRepeatedBalance["endTime"] = Timestamp.fromDate(
                time!.toDate().subtract(
                      Duration(
                        seconds: oldRepeatedBalance["repeatDuration"] as int,
                      ),
                    ),
              );
            }
            final Map<String, dynamic> changes = <String, dynamic>{
              "amount": amount,
              "category": category,
              "currency": currency,
              "name": name,
              "initialTime": time,
              "repeatDuration": repeatDuration,
              "repeatDurationType": repeatDurationType,
            };
            changes.removeWhere((_, value) => value == null);
            newRepeatedBalance.addAll(changes);

            removeUnusedChangedAttributes(newRepeatedBalance);
            removeUnusedChangedAttributes(oldRepeatedBalance);

            isEdited = true;
          }
        }
        (data["repeatedBalance"] as List<dynamic>).add(newRepeatedBalance);

        break;
      case RepeatableChangeType.onlyThisOne:
        for (final singleRepeatedBalance
            in data["repeatedBalance"] as List<dynamic>) {
          singleRepeatedBalance as Map<String, dynamic>;
          if (singleRepeatedBalance["id"] == id) {
            if (singleRepeatedBalance["changed"] == null) {
              singleRepeatedBalance["changed"] =
                  <String, Map<String, dynamic>>{};
            }
            (singleRepeatedBalance["changed"]
                    as Map<String, Map<String, dynamic>>)
                .addAll({
              time!.millisecondsSinceEpoch.toString(): {
                "amount": amount,
                "category": category,
                "currency": currency,
                "name": name,
              }
            });
            (singleRepeatedBalance["changed"]
                        as Map<String, Map<String, dynamic>>)[
                    time.millisecondsSinceEpoch.toString()]
                ?.removeWhere((_, value) => value == null);
          }
          break;
        }
    }

    if (isEdited) {
      await _balance!.set(data);
    }
    return true;
  }

  /// [id] is the id of the repeatedBalance
  /// [removeType] decides what data should be removed from the balanceData. RemoveType.none should only be used for repeatedData with endDate
  /// [time] is required if you want to use RemoveType.allBefore or RemoveType.allAfter
  Future<bool> removeRepeatedBalanceUsingId({
    required String id,
    required RepeatableChangeType removeType,
    Timestamp? time,
  }) async {
    if (_balance == null) {
      dev.log("_balance is null");
      return false;
    }
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();

    if (removeType != RepeatableChangeType.all && time == null) {
      return false;
    }
    switch (removeType) {
      case RepeatableChangeType.all:
        final int length = (data!["repeatedBalance"] as List<dynamic>).length;
        (data["repeatedBalance"] as List<dynamic>).removeWhere((element) {
          return (element as Map<String, dynamic>)["id"] == id;
        });
        if (length == (data["repeatedBalance"] as List<dynamic>).length) {
          dev.log("The repeatable balance wasn't found");
          return false;
        }
        break;
      case RepeatableChangeType.thisAndAllBefore:
        for (final Map<String, dynamic> singleRepeatedBalance
            in data!["repeatedBalance"]) {
          if (singleRepeatedBalance["id"] == id) {
            if ((singleRepeatedBalance["repeatDurationType"] as String)
                    .toUpperCase() ==
                "MONTHS") {
              singleRepeatedBalance["initialTime"] = Timestamp.fromDate(
                DateTime(
                  time!.toDate().year,
                  time.toDate().month +
                      (singleRepeatedBalance["repeatDuration"] as int),
                  time.toDate().day,
                ),
              );
            } else {
              // if not month => seconds
              singleRepeatedBalance["initialTime"] = Timestamp.fromDate(
                time!.toDate().add(
                      Duration(
                        seconds: singleRepeatedBalance["repeatDuration"] as int,
                      ),
                    ),
              );
            }

            break;
          }
        }
        break;
      case RepeatableChangeType.thisAndAllAfter:
        for (final Map<String, dynamic> singleRepeatedBalance
            in data!["repeatedBalance"]) {
          if (singleRepeatedBalance["id"] == id) {
            if ((singleRepeatedBalance["repeatDurationType"] as String)
                    .toUpperCase() ==
                "MONTHS") {
              singleRepeatedBalance["endTime"] = Timestamp.fromDate(
                DateTime(
                  time!.toDate().year,
                  time.toDate().month -
                      (singleRepeatedBalance["repeatDuration"] as int),
                  time.toDate().day,
                ),
              );
            } else {
              // if not month => seconds
              singleRepeatedBalance["endTime"] = Timestamp.fromDate(
                time!.toDate().subtract(
                      Duration(
                        seconds: singleRepeatedBalance["repeatDuration"] as int,
                      ),
                    ),
              );
            }
            break;
          }
        }
        break;
      case RepeatableChangeType.onlyThisOne:
        for (final Map<String, dynamic> singleRepeatedBalance
            in data!["repeatedBalance"]) {
          if (singleRepeatedBalance["id"] == id) {
            if (singleRepeatedBalance["changed"] == null) {
              singleRepeatedBalance["changed"] =
                  <String, Map<String, dynamic>>{};
            }
            (singleRepeatedBalance["changed"]
                    as Map<String, Map<String, dynamic>>)
                .addAll({
              time!.millisecondsSinceEpoch.toString(): {
                "deleted": true,
              }
            });
            break;
          }
        }

        break;
    }
    dev.log("");
    await _balance!.set(data);
    return true;
  }

  Future<bool> removeRepeatedBalance({
    required RepeatBalanceData repeatBalanceData,
    required RepeatableChangeType removeType,
    Timestamp? time,
  }) async {
    return removeRepeatedBalanceUsingId(
      id: repeatBalanceData.id,
      removeType: removeType,
      time: time,
    );
  }

  // void _redoRepeatable(
  //   dynamic singleRepeatedBalance,
  //   List<Map<String, dynamic>> balanceData,
  // ) {
  //   _deleteAllCopiesOfRepeatableLocally(
  //     (singleRepeatedBalance as Map<String, dynamic>)["id"] as String,
  //     balanceData,
  //   );
  //   _addSingleRepeatableToBalanceDataLocally(
  //     singleRepeatedBalance,
  //     balanceData,
  //   );
  // }

  // Future<void> _deleteAllCopiesOfRepeatable(String id) async {
  //   final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //       await _balance!.get();
  //   final Map<String, dynamic>? data = snapshot.data();

  //   // _deleteAllCopiesOfRepeatableLocally(id, balanceData);
  //   return _balance!.set(data!);
  // }

  // void _deleteAllCopiesOfRepeatableLocally(
  //   String id,
  //   List<Map<String, dynamic>> balanceData,
  // ) {
  //   balanceData.removeWhere(
  //     (element) => element["repeatId"] == id,
  //   );
  // }

  // Future<void> _deleteAllNewerCopiesOfRepeatable(
  //   String id,
  //   Timestamp time,
  // ) async {
  //   final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //       await _balance!.get();
  //   final Map<String, dynamic>? data = snapshot.data();

  //   _deleteAllNewerCopiesOfRepeatableLocally(id, data, time);
  //   return _balance!.set(data!);
  // }

  // void _deleteAllNewerCopiesOfRepeatableLocally(
  //   String id,
  //   Map<String, dynamic>? data,
  //   Timestamp time,
  // ) {
  //   (data!["balanceData"] as List<dynamic>).removeWhere(
  //     (element) =>
  //         (element as Map<String, dynamic>)["repeatId"] == id &&
  //         (element["time"] as Timestamp).compareTo(time) >= 0,
  //   );
  //   for (final element in data["balanceData"] as List<dynamic>) {
  //     if ((element as Map<String, dynamic>)["repeatId"] == id) {
  //       element["repeatId"] = null;
  //     }
  //   }
  // }

  // Future<void> _deleteAllOlderCopiesOfRepeatable(
  //   String id,
  //   Timestamp time,
  // ) async {
  //   final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //       await _balance!.get();
  //   final Map<String, dynamic>? data = snapshot.data();

  //   _deleteAllOlderCopiesOfRepeatableLocally(id, data, time);
  //   return _balance!.set(data!);
  // }

  // void _deleteAllOlderCopiesOfRepeatableLocally(
  //   String id,
  //   Map<String, dynamic>? data,
  //   Timestamp time,
  // ) {
  //   (data!["balanceData"] as List<dynamic>).removeWhere(
  //     (element) =>
  //         (element as Map<String, dynamic>)["repeatId"] == id &&
  //         (element["time"] as Timestamp).compareTo(time) <= 0,
  //   );
  //   for (final element in data["balanceData"] as List<dynamic>) {
  //     if ((element as Map<String, dynamic>)["repeatId"] == id) {
  //       element["repeatId"] = null;
  //     }
  //   }
  // }

  // Future<void> _addSingleRepeatableToBalanceData(
  //   Map<String, dynamic> singleRepeatedBalance,
  // ) async {
  //   final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //       await _balance!.get();
  //   final Map<String, dynamic>? data = snapshot.data();
  //   _addSingleRepeatableToBalanceDataLocally(singleRepeatedBalance, data);
  //   return _balance!.set(data!);
  // }

  void addAllRepeatablesToBalanceDataLocally(
    List<Map<String, dynamic>> repeatedBalance,
    List<Map<String, dynamic>> balanceData,
  ) {
    for (final singleRepeatedBalance in repeatedBalance) {
      addSingleRepeatableToBalanceDataLocally(
        singleRepeatedBalance,
        balanceData,
      );
    }
  }

  void addSingleRepeatableToBalanceDataLocally(
    Map<String, dynamic> singleRepeatedBalance,
    List<Map<String, dynamic>> balanceData,
  ) {
    DateTime currentTime =
        (singleRepeatedBalance["initialTime"] as Timestamp).toDate();

    // Duration futureDuration =
    //     Duration(seconds: singleRepeatedBalance["repeatDuration"] * 30);
    // if (futureDuration.inSeconds < FUTURE_DURATION.inSeconds) {
    //   futureDuration = FUTURE_DURATION;
    // }

    const Duration futureDuration = Duration(days: 365);

    // while we are before 1 years after today / before endTime
    while ((singleRepeatedBalance["endTime"] != null)
        // !isbefore => currentime = endtime = true
        ? !(singleRepeatedBalance["endTime"] as Timestamp).toDate().isBefore(
              currentTime,
            )
        : DateTime.now().add(futureDuration).isAfter(currentTime)) {
      // if "changed" -> "this timestamp" -> deleted exist AND it is true, dont add this balance

      if (singleRepeatedBalance["changed"] == null ||
          (singleRepeatedBalance["changed"] as Map<String, dynamic>)[
                  Timestamp.fromDate(currentTime)
                      .millisecondsSinceEpoch
                      .toString()] ==
              null ||
          ((singleRepeatedBalance["changed"] as Map<String, dynamic>)[
                  Timestamp.fromDate(currentTime)
                      .millisecondsSinceEpoch
                      .toString()] as Map<String, dynamic>)["deleted"] ==
              null ||
          !(((singleRepeatedBalance["changed"]
                  as Map<String, dynamic>)[Timestamp.fromDate(currentTime).millisecondsSinceEpoch.toString()]
              as Map<String, dynamic>)["deleted"] as bool)) {
        balanceData.add({
          "amount": singleRepeatedBalance["amount"],
          "category": singleRepeatedBalance["category"],
          "currency": singleRepeatedBalance["currency"],
          "name": singleRepeatedBalance["name"],
          "time": Timestamp.fromDate(currentTime),
          "repeatId": singleRepeatedBalance["id"],
          "id": const Uuid().v4(),
        });
      }
      currentTime =
          calculateNextCurrentTime(singleRepeatedBalance, currentTime);
    }
  }

  DateTime calculateNextCurrentTime(
    Map<String, dynamic> singleRepeatedBalance,
    DateTime currentTime,
  ) {
    late DateTime newCurrentTime;
    if (singleRepeatedBalance["repeatDurationType"] == null ||
        (singleRepeatedBalance["repeatDurationType"] as String).toUpperCase() ==
            "SECONDS") {
      newCurrentTime = currentTime.add(
        Duration(
          seconds: singleRepeatedBalance["repeatDuration"] as int,
        ),
      );
    } else if ((singleRepeatedBalance["repeatDurationType"] as String)
            .toUpperCase() ==
        "MONTHS") {
      newCurrentTime = currentTimeRecalculator(
        currentTime.year,
        currentTime.month +
            (singleRepeatedBalance["repeatDuration"] as num).floor(),
        (singleRepeatedBalance["initialTime"] as Timestamp).toDate().day,
      );
    }
    return newCurrentTime;
  }

  DateTime currentTimeRecalculator(int year, int month, int day) {
    final DateTime temp = DateTime(year, month, day);
    if (temp.month == month || month == 13) {
      return temp;
    } else {
      return DateTime(temp.year, temp.month).subtract(const Duration(days: 1));
    }
  }

  void removeUnusedChangedAttributes(
    Map<String, dynamic> singleRepeatedBalance,
  ) {
    if (singleRepeatedBalance["changes"] == null) {
      return;
    }
    final List<String> keysToRemove = <String>[];
    for (final timeStampString
        in (singleRepeatedBalance["changes"] as Map<String, dynamic>).keys) {
      if (!DateTime.fromMillisecondsSinceEpoch(
            (num.tryParse(timeStampString) as int?) ?? 0,
          ).isBefore(
            (singleRepeatedBalance["initialTime"] as Timestamp).toDate(),
          ) &&
          !DateTime.fromMillisecondsSinceEpoch(
            (num.tryParse(timeStampString) as int?) ?? 0,
          ).isAfter(
            (singleRepeatedBalance["endTime"] as Timestamp).toDate(),
          )) {
        keysToRemove.add(timeStampString);
      }
    }
    for (final key in keysToRemove) {
      (singleRepeatedBalance["changes"] as Map<String, dynamic>).remove(key);
    }
  }

  // Settings

  Future<void> uploadSettings(Map<String, dynamic> settings) async {
    if (_balance == null) {
      dev.log("_balance is null");
    }
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    data!["settings"] = settings;
    await _balance!.set(data);
  }

  Future<Map<String, dynamic>> getSettings() async {
    if (_balance == null) {
      dev.log("_balance is null");
    }
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    return data!["settings"] as Map<String, dynamic>;
  }
}
