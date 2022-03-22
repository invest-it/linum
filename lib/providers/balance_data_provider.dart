// ignore_for_file: unused_element, avoid_dynamic_calls

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';
import 'package:linum/models/repeat_duration_type_enum.dart';
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
        log("error getting doc id");
        return;
      }
      if (docs.isEmpty) {
        docs = await _createDoc();
      }

      // Future support multiple docs per user
      _balance = FirebaseFirestore.instance
          .collection('balance')
          .doc(docs[0] as String);
      await _addRepeatablesToBalanceData();
      notifyListeners();
    } else {
      log("no data found in documentToUser");
    }
  }

  Future<List<dynamic>> _createDoc() async {
    log("creating document");
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
          final Map<String, dynamic>? data =
              (snapshot.data as DocumentSnapshot<Map<String, dynamic>>).data();
          final List<dynamic> balanceData =
              data!["balanceData"] as List<dynamic>;

          // log(balanceData[0].runtimeType.toString());

          // Future there could be an sort algorithm provider
          // (and possibly also a filter algorithm provided)
          balanceData.sort(_algorithmProvider.currentSorter);
          balanceData.removeWhere(_algorithmProvider.currentFilter);
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
          final Map<String, dynamic>? data =
              (snapshot.data as DocumentSnapshot<Map<String, dynamic>>).data();
          final List<dynamic> balanceData =
              data!["balanceData"] as List<dynamic>;

          balanceData.removeWhere(_algorithmProvider.currentFilter);
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(balanceData);
          statisticPanel.addStatisticData(statisticsCalculations);
          return statisticPanel.returnWidget;
        }
      },
    );
  }

  /// add a single Balance and upload it
  Future<bool> addSingleBalance({
    required num amount,
    required String category,
    required String currency,
    required String name,
    required Timestamp time,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }
    if (category == "" || currency == "" /* || name == "" */) {
      return false;
    }
    final Map<String, dynamic> singleBalance = {
      "amount": amount,
      "category": category,
      "currency": currency,
      "name": name,
      "time": time,
      "id": const Uuid().v4(),
    };
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    data!["balanceData"]!.add(singleBalance);
    await _balance!.set(data);
    return true;
  }

  /// remove a single Balance and upload it (identified using id)
  Future<bool> removeSingleBalance(String id) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    final int dataLength = (data!["balanceData"] as List<dynamic>).length;
    (data["balanceData"] as List<dynamic>).removeWhere((value) {
      return value["id"] == id || value["id"] == null; // Auto delete trash data
    });
    if (dataLength > (data["balanceData"] as List<dynamic>).length) {
      await _balance!.set(data);
      return true;
    }
    return false;
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
      log("_balance is null");
      return false;
    }
    if (id == "") {
      log("no id provided");
      return false;
    }
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    data!["balanceData"].forEach((value) {
      if (value["id"] == id) {
        value["amount"] = amount ?? value["amount"];
        value["category"] = category ?? value["category"];
        value["currency"] = currency ?? value["currency"];
        value["name"] = name ?? value["name"];
        value["time"] = time ?? value["time"];
      }
    });
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

  Future<void> _addRepeatablesToBalanceData() async {
    final DocumentSnapshot<Map<String, dynamic>> dataDoc =
        await _balance!.get();
    final Map<String, dynamic>? data = dataDoc.data();
    if (data!["repeatedBalance"] == null) {
      return;
    }
    // log(data["repeatedBalance"].toString());
    for (int i = 0;
        i < (data["repeatedBalance"] as List<dynamic>).length;
        i++) {
      final dynamic singleRepeatedBalance = data["repeatedBalance"][i];
      if (singleRepeatedBalance["lastUpdate"] == null) {
        singleRepeatedBalance["lastUpdate"] = Timestamp(0, 0);
      }

      if (singleRepeatedBalance != null &&
              ((singleRepeatedBalance["repeatDurationType"] == "SECONDS" ||
                      singleRepeatedBalance["repeatDurationType"] == null) &&
                  (singleRepeatedBalance["lastUpdate"] as Timestamp)
                      .toDate()
                      .add(
                        Duration(
                          seconds:
                              singleRepeatedBalance["repeatDuration"] as int,
                        ),
                      )
                      .isBefore(DateTime.now())) ||
          (singleRepeatedBalance["repeatDurationType"] == "MONTHS" &&
              DateTime(
                (singleRepeatedBalance["lastUpdate"] as Timestamp)
                    .toDate()
                    .year,
                (singleRepeatedBalance["lastUpdate"] as Timestamp)
                        .toDate()
                        .month +
                    (singleRepeatedBalance["repeatDuration"] as num).floor(),
                (singleRepeatedBalance["lastUpdate"] as Timestamp).toDate().day,
              ).isBefore(DateTime.now()))) {
        _addSingleRepeatableToBalanceDataLocally(singleRepeatedBalance, data);
      }
    }
    await _balance!.set(data);
  }

  // .
  Future<bool> addRepeatedBalance({
    required num amount,
    required String category,
    required String currency,
    required String name,
    required Timestamp initialTime,
    required int repeatDuration,
    RepeatDurationType repeatDurationType = RepeatDurationType.seconds,
    Timestamp? endTime,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }
    if (category == "" || currency == "" /* || name == "" */) {
      return false;
    }
    final Map<String, dynamic> singleRepeatedBalance = {
      "amount": amount,
      "category": category,
      "currency": currency,
      "name": name,
      "initialTime": initialTime,
      "repeatDuration": repeatDuration,
      "repeatDurationType": repeatDurationType.toString().substring(19),
      "endTime": endTime,
      "id": const Uuid().v4(),
    };
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    data!["repeatedBalance"].add(singleRepeatedBalance);
    _addSingleRepeatableToBalanceDataLocally(singleRepeatedBalance, data);
    await _balance!.set(data);
    return true;
  }

  // .
  Future<bool> updateRepeatedBalance({
    required String id,
    num? amount,
    String? category,
    String? currency,
    String? name,
    Timestamp? initialTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    Timestamp? endTime,
    bool? resetEndTime,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }
    bool isEdited = false;
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    data!["repeatedBalance"].forEach((value) {
      if (!isEdited && (value["id"] == id)) {
        if (amount != null && amount != value["amount"]) {
          value["amount"] = amount;
          isEdited = true;
        }
        if (category != null && category != value["category"]) {
          value["category"] = category;
          isEdited = true;
        }
        if (currency != null && currency != value["currency"]) {
          value["currency"] = currency;
          isEdited = true;
        }
        if (name != null && name != value["name"]) {
          value["name"] = name;
          isEdited = true;
        }
        if (initialTime != null && initialTime != value["initialTime"]) {
          value["initialTime"] = initialTime;
          isEdited = true;
        }
        if (repeatDuration != null &&
            repeatDuration != value["repeatDuration"]) {
          value["repeatDuration"] = repeatDuration;
          isEdited = true;
        }
        if (repeatDurationType != null &&
            repeatDurationType !=
                EnumToString.fromString<RepeatDurationType>(
                  RepeatDurationType.values,
                  value["repeatDurationType"] as String,
                )) {
          value["repeatDuration"] = repeatDurationType.toString().substring(19);
          isEdited = true;
        }
        if (endTime != null && endTime != value["endTime"]) {
          value["endTime"] = endTime;
          isEdited = true;
        }
        if (resetEndTime != null && resetEndTime) {
          value[endTime] = null;
          isEdited = true;
        }
      }
    });
    if (isEdited) {
      _redoRepeatable(
        (data["repeatedBalance"] as List<dynamic>)
            .firstWhere((element) => element["id"] != id),
        data,
      );
      await _balance!.set(data);
    }
    return isEdited;
  }

  /// [id] is the id of the repeatedBalance
  /// [removeType] decides what data should be removed from the balanceData. RemoveType.none should only be used for repeatedData with endDate
  /// [time] is required if you want to use RemoveType.allBefore or RemoveType.allAfter
  Future<bool> removeRepeatedBalance({
    required String id,
    required RemoveType removeType,
    Timestamp? time,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    final int length = (data!["repeatedBalance"] as List<dynamic>).length;
    (data["repeatedBalance"] as List<dynamic>).removeWhere((element) {
      return element["id"] == id;
    });
    if (length == (data["repeatedBalance"] as List<dynamic>).length) {
      return false;
    }
    if (removeType != RemoveType.all &&
        removeType != RemoveType.none &&
        time == null) {
      return false;
    }
    switch (removeType) {
      case RemoveType.all:
        _deleteAllCopiesOfRepeatableLocally(id, data);
        break;
      case RemoveType.allBefore:
        _deleteAllOlderCopiesOfRepeatableLocally(id, data, time!);
        break;
      case RemoveType.allAfter:
        _deleteAllNewerCopiesOfRepeatableLocally(id, data, time!);
        break;
      case RemoveType.none:
        for (final element in data["balanceData"] as List<dynamic>) {
          if (element["repeatId"] == id) {
            element["repeatId"] = null;
          }
        }
        break;
    }
    await _balance!.set(data);
    return true;
  }

  void _redoRepeatable(
    dynamic singleRepeatedBalance,
    Map<String, dynamic>? data,
  ) {
    _deleteAllCopiesOfRepeatableLocally(
      singleRepeatedBalance["id"] as String,
      data,
    );
    _addSingleRepeatableToBalanceDataLocally(singleRepeatedBalance, data);
  }

  Future<void> _deleteAllCopiesOfRepeatable(String id) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();

    _deleteAllCopiesOfRepeatableLocally(id, data);
    return _balance!.set(data!);
  }

  void _deleteAllCopiesOfRepeatableLocally(
    String id,
    Map<String, dynamic>? data,
  ) {
    (data!["balanceData"] as List<dynamic>)
        .removeWhere((element) => element["repeatId"] == id);
  }

  Future<void> _deleteAllNewerCopiesOfRepeatable(
    String id,
    Timestamp time,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();

    _deleteAllNewerCopiesOfRepeatableLocally(id, data, time);
    return _balance!.set(data!);
  }

  void _deleteAllNewerCopiesOfRepeatableLocally(
    String id,
    Map<String, dynamic>? data,
    Timestamp time,
  ) {
    (data!["balanceData"] as List<dynamic>).removeWhere(
      (element) =>
          element["repeatId"] == id &&
          (element["time"] as Timestamp).compareTo(time) >= 0,
    );
    for (final element in data["balanceData"] as List<dynamic>) {
      if (element["repeatId"] == id) {
        element["repeatId"] = null;
      }
    }
  }

  Future<void> _deleteAllOlderCopiesOfRepeatable(
    String id,
    Timestamp time,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();

    _deleteAllOlderCopiesOfRepeatableLocally(id, data, time);
    return _balance!.set(data!);
  }

  void _deleteAllOlderCopiesOfRepeatableLocally(
    String id,
    Map<String, dynamic>? data,
    Timestamp time,
  ) {
    (data!["balanceData"] as List<dynamic>).removeWhere(
      (element) =>
          element["repeatId"] == id &&
          (element["time"] as Timestamp).compareTo(time) <= 0,
    );
    for (final element in data["balanceData"] as List<dynamic>) {
      if (element["repeatId"] == id) {
        element["repeatId"] = null;
      }
    }
  }

  Future<void> _addSingleRepeatableToBalanceData(
    dynamic singleRepeatedBalance,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    _addSingleRepeatableToBalanceDataLocally(singleRepeatedBalance, data);
    return _balance!.set(data!);
  }

  void _addSingleRepeatableToBalanceDataLocally(
    dynamic singleRepeatedBalance,
    Map<String, dynamic>? data,
  ) {
    DateTime currentTime =
        (singleRepeatedBalance["initialTime"] as Timestamp).toDate();
    bool didUpdate = false;

    // Duration futureDuration =
    //     Duration(seconds: singleRepeatedBalance["repeatDuration"] * 30);
    // if (futureDuration.inSeconds < FUTURE_DURATION.inSeconds) {
    //   futureDuration = FUTURE_DURATION;
    // }

    const Duration futureDuration = Duration(days: 365);
    if (singleRepeatedBalance["repeatDurationType"] == "SECONDS" ||
        singleRepeatedBalance["repeatDurationType"] == null) {
      // while we are before 1 years after today / before endTime
      while ((singleRepeatedBalance["endTime"] != null)
          ? currentTime.isBefore(
              (singleRepeatedBalance["endTime"] as Timestamp).toDate(),
            )
          : currentTime.isBefore(DateTime.now().add(futureDuration))) {
        // why does this work?
        if (singleRepeatedBalance["lastUpdate"] == null ||
            DateTime.now()
                .add(
                  Duration(
                    seconds: singleRepeatedBalance["repeatDuration"] as int,
                  ),
                )
                .isAfter(
                  (singleRepeatedBalance["lastUpdate"] as Timestamp).toDate(),
                )) {
          didUpdate = true;
          (data!["balanceData"] as List<dynamic>).add({
            "amount": singleRepeatedBalance["amount"],
            "category": singleRepeatedBalance["category"],
            "currency": singleRepeatedBalance["currency"],
            "name": singleRepeatedBalance["name"],
            "time": Timestamp.fromDate(currentTime),
            "repeatId": singleRepeatedBalance["id"],
            "id": const Uuid().v4(),
          });
          currentTime = currentTime.add(
            Duration(
              seconds: singleRepeatedBalance["repeatDuration"] as int,
            ),
          );
        }
      }
    } else if (singleRepeatedBalance["repeatDurationType"] == "MONTHS") {
      // while we are before 1 years after today / before endTime
      while ((singleRepeatedBalance["endTime"] != null)
          ? currentTime.isBefore(
              (singleRepeatedBalance["endTime"] as Timestamp).toDate(),
            )
          : currentTime.isBefore(DateTime.now().add(futureDuration))) {
        if (singleRepeatedBalance["lastUpdate"] == null ||
            DateTime(
              DateTime.now().year,
              DateTime.now().month +
                  (singleRepeatedBalance["repeatDuration"] as num).floor(),
              DateTime.now().day,
            ).isAfter(
              (singleRepeatedBalance["lastUpdate"] as Timestamp).toDate(),
            )) {
          didUpdate = true;
          (data!["balanceData"] as List<dynamic>).add({
            "amount": singleRepeatedBalance["amount"],
            "category": singleRepeatedBalance["category"],
            "currency": singleRepeatedBalance["currency"],
            "name": singleRepeatedBalance["name"],
            "time": Timestamp.fromDate(currentTime),
            "repeatId": singleRepeatedBalance["id"],
            "id": const Uuid().v4(),
          });
        }

        currentTime = currentTimeRecalculator(
          currentTime.year,
          currentTime.month +
              (singleRepeatedBalance["repeatDuration"] as num).floor(),
          (singleRepeatedBalance["initialTime"] as Timestamp).toDate().day,
        );
      }
    }

    if (didUpdate) {
      singleRepeatedBalance["lastUpdate"] = Timestamp.fromDate(DateTime.now());
    }
  }

  DateTime currentTimeRecalculator(int year, int month, int day) {
    final DateTime temp = DateTime(year, month, day);
    if (temp.month == month || month == 13) {
      return temp;
    } else {
      return DateTime(temp.year, temp.month).subtract(const Duration(days: 1));
    }
  }

  Future<void> uploadSettings(Map<String, dynamic> settings) async {
    if (_balance == null) {
      log("_balance is null");
    }
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    data!["settings"] = settings;
    await _balance!.set(data);
  }

  Future<Map<String, dynamic>> getSettings() async {
    if (_balance == null) {
      log("_balance is null");
    }
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();
    return data!["settings"] as Map<String, dynamic>;
  }
}

enum RemoveType {
  all,
  allBefore,
  allAfter,
  none,
}
