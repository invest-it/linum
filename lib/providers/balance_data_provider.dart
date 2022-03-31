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

  /// Creates Document if it doesn't exist
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

  /// update [_uid] if it is new. redo the document connections
  void updateAuth(AuthenticationService? auth) {
    if (auth != null && auth.uid != _uid) {
      _uid = auth.uid;
      asynConstructor();
    }
  }

  /// update [_algorithmProvider] if it is new. redo the document connections
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

  /// use the snapshot to get all data from the document.
  /// convert the List<dynamic> to a List<Map<String, dynamic>>
  /// use the repeatedbalancedata to create the missing balance data
  /// use the current _algorithmProvider filter
  /// (will still be used after filter on firebase, because of repeated balanced)
  /// may be moved into the data generation function
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

  /// it is an alias for removeSingleBalanceUsingId(singleBalance.id);
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

  /// balance data povider gets disposed after closing the enter screen. we want to skip disposing one time.
  void dontDisposeOneTime() {
    _dontDispose++;
  }

  /// balance data povider gets disposed after closing the enter screen. we want to skip disposing one time.
  @override
  void dispose() {
    if (_dontDispose-- == 0) {
      super.dispose();
    }
  }

  /// add a repeated Balance and upload it (the stream will automatically show it in the app again)
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

  /// update a repeated balance
  /// specify time if changeType != RepeatableChangeType.all
  /// resetEndTime, endTime are no available for RepeatableChangeType.thisAndAllBefore
  /// RepeatableChangeType.thisAndAllBefore and RepeatableChangeType.thisAndAllAfter will split the repeated balance to 2
  Future<bool> updateRepeatedBalance({
    required String id,
    required RepeatableChangeType changeType,
    num? checkedAmount,
    String? checkedCategory,
    String? checkedCurrency,
    String? checkedName,
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
    if (changeType == RepeatableChangeType.thisAndAllBefore) {
      if (resetEndTime ?? false || endTime != null) {
        dev.log(
          "resetEndTime, endTime are no available for RepeatableChangeType.thisAndAllBefore",
        );
        return false;
      }
    }
    bool isEdited = false;
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    if (data == null) {
      return false;
    }
    for (final singleRepeatedBalance
        in data["repeatedBalance"] as List<dynamic>) {
      singleRepeatedBalance as Map<String, dynamic>;
      if (!isEdited && (singleRepeatedBalance["id"] == id)) {
        if (checkedAmount == singleRepeatedBalance["amount"]) {
          checkedAmount = null;
        }
        break;
      }
    }
    switch (changeType) {
      case RepeatableChangeType.all:
        for (final singleRepeatedBalance
            in data["repeatedBalance"] as List<dynamic>) {
          singleRepeatedBalance as Map<String, dynamic>;
          if (!isEdited && (singleRepeatedBalance["id"] == id)) {
            if (checkedAmount != null) {
              singleRepeatedBalance["amount"] = checkedAmount;
              isEdited = true;
            }
            if (checkedCategory != null &&
                checkedCategory != singleRepeatedBalance["category"]) {
              singleRepeatedBalance["category"] = checkedCategory;
              isEdited = true;
            }
            if (checkedCurrency != null &&
                checkedCurrency != singleRepeatedBalance["currency"]) {
              singleRepeatedBalance["currency"] = checkedCurrency;
              isEdited = true;
            }
            if (checkedName != null &&
                checkedName != singleRepeatedBalance["name"]) {
              singleRepeatedBalance["name"] = checkedName;
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
                  if (checkedAmount != null) {
                    (value as Map<String, dynamic>).remove("amount");
                  }
                  if (checkedCategory != null) {
                    (value as Map<String, dynamic>).remove("category");
                  }
                  if (checkedCurrency != null) {
                    (value as Map<String, dynamic>).remove("currency");
                  }
                  if (checkedName != null) {
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
              "amount": checkedAmount,
              "category": checkedCategory,
              "currency": checkedCurrency,
              "name": checkedName,
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
              "amount": checkedAmount,
              "category": checkedCategory,
              "currency": checkedCurrency,
              "name": checkedName,
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
                "amount": checkedAmount,
                "category": checkedCategory,
                "currency": checkedCurrency,
                "name": checkedName,
              }
            });
            (singleRepeatedBalance["changed"]
                        as Map<String, Map<String, dynamic>>)[
                    time.millisecondsSinceEpoch.toString()]
                ?.removeWhere((_, value) => value == null);
            isEdited = true;
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

  /// it is an alias for removeRepeatedBalanceUsingId with that repeatBalanceData.id
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

  /// goes trough the repeatable list and uses addSingleRepeatableToBalanceDataLocally
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

  /// adds a repeatable for the whole needed duration up to one year with all needed "changes" into the balancedata
  void addSingleRepeatableToBalanceDataLocally(
    Map<String, dynamic> singleRepeatedBalance,
    List<Map<String, dynamic>> balanceData,
  ) {
    DateTime currentTime =
        (singleRepeatedBalance["initialTime"] as Timestamp).toDate();

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
          "amount":
              ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                      Timestamp.fromDate(currentTime)
                          .millisecondsSinceEpoch
                          .toString()] as Map<String, dynamic>?)?["amount"] ??
                  singleRepeatedBalance["amount"],
          "category":
              ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                      Timestamp.fromDate(currentTime)
                          .millisecondsSinceEpoch
                          .toString()] as Map<String, dynamic>?)?["category"] ??
                  singleRepeatedBalance["category"],
          "currency":
              ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                      Timestamp.fromDate(currentTime)
                          .millisecondsSinceEpoch
                          .toString()] as Map<String, dynamic>?)?["currency"] ??
                  singleRepeatedBalance["currency"],
          "name": ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                  Timestamp.fromDate(currentTime)
                      .millisecondsSinceEpoch
                      .toString()] as Map<String, dynamic>?)?["name"] ??
              singleRepeatedBalance["name"],
          "time": ((singleRepeatedBalance["changed"] as Map<String, dynamic>?)?[
                  Timestamp.fromDate(currentTime)
                      .millisecondsSinceEpoch
                      .toString()] as Map<String, dynamic>?)?["time"] ??
              Timestamp.fromDate(currentTime),
          "repeatId": singleRepeatedBalance["id"],
          "id": const Uuid().v4(),
        });
      }
      currentTime =
          calculateNextCurrentTime(singleRepeatedBalance, currentTime);
    }
  }

  /// calculate next time step and decide for that if you need monthly steps or seconds as stepsize
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

  /// avoid errors with 29th 30th and 31th
  DateTime currentTimeRecalculator(int year, int month, int day) {
    final DateTime temp = DateTime(year, month, day);
    if (temp.month == month || month == 13) {
      return temp;
    } else {
      return DateTime(temp.year, temp.month).subtract(const Duration(days: 1));
    }
  }

  /// after splitting a repeatable delete copied "changes" attributes that are out of the time limits of that repeatable
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

  /// upload one setting as map
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

  /// get settings as map
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
