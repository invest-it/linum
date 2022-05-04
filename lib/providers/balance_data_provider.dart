import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/balance_data/balance_data_stream_builder_manager.dart';
import 'package:linum/balance_data/repeated_balance_data_manager.dart';
import 'package:linum/balance_data/single_balance_data_manager.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/repeat_duration_type_enum.dart';
import 'package:linum/models/repeatable_change_type.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/abstract/abstract_home_screen_card.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:provider/provider.dart';

/// Provides the balance data from the database using the uid.
class BalanceDataProvider extends ChangeNotifier {
  /// _balance is the documentReference to get the balance data from the database. It will be null if the constructor isnt ready yet
  DocumentReference<Map<String, dynamic>>? _balance;

  /// The uid of the user
  late String _uid;

  late AlgorithmProvider _algorithmProvider;

  num _dontDispose = 0;

  // Manager
  late final SingleBalanceDataManager singleBalanceDataManager;
  late final RepeatedBalanceDataManager repeatedBalanceDataManager;
  late final BalanceDataStreamBuilderManager balanceDataStreamBuilderManager;

  /// Creates the BalanceDataProvider. Inparticular it sets [_balance] correctly
  BalanceDataProvider(BuildContext context) {
    singleBalanceDataManager = SingleBalanceDataManager();
    repeatedBalanceDataManager = RepeatedBalanceDataManager();
    balanceDataStreamBuilderManager = BalanceDataStreamBuilderManager();

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

  /// add a single Balance and upload it
  Future<bool> addSingleBalance(SingleBalanceData singleBalance) async {
    // get Data
    final Map<String, dynamic>? data = await _getData();
    if (data == null) {
      return false;
    }

    // add and upload
    if (singleBalanceDataManager.addSingleBalanceToData(singleBalance, data)) {
      await _balance!.set(data);
      return true;
    }

    dev.log("couldn't add single balance");
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
    // get Data
    final Map<String, dynamic>? data = await _getData();
    if (data == null) {
      return false;
    }

    // update and upload
    if (singleBalanceDataManager.updateSingleBalanceInData(
      id,
      data,
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      time: time,
    )) {
      await _balance!.set(data);
      return true;
    }

    await _balance!.update(data);
    return true;
  }

  /// remove a single Balance and upload it (identified using id)
  Future<bool> removeSingleBalanceUsingId(String id) async {
    // get Data
    final Map<String, dynamic>? data = await _getData();
    if (data == null) {
      return false;
    }

    // remove and upload
    if (singleBalanceDataManager.removeSingleBalanceFromData(id, data)) {
      await _balance!.set(data);
      return true;
    }

    dev.log("couldn't remove single balance");
    return false;
  }

  /// it is an alias for removeSingleBalanceUsingId(singleBalance.id);
  Future<bool> removeSingleBalance(SingleBalanceData singleBalance) {
    return removeSingleBalanceUsingId(singleBalance.id);
  }

  Future<Map<String, dynamic>?> _getData() async {
    // check connection
    if (_balance == null) {
      dev.log("_balance is null");
      return null;
    }

    // get data
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _balance!.get();
    final Map<String, dynamic>? data = snapshot.data();

    // check if data exists
    if (data == null) {
      dev.log("Corrupted User Document");
      return null;
    }

    return data;
  }

  /// add a repeated Balance and upload it (the stream will automatically show it in the app again)
  Future<bool> addRepeatedBalance(
    RepeatedBalanceData repeatBalanceData,
  ) async {
    // get Data
    final Map<String, dynamic>? data = await _getData();
    if (data == null) {
      return false;
    }

    // add and upload
    if (repeatedBalanceDataManager.addRepeatedBalanceToData(
      repeatBalanceData,
      data,
    )) {
      await _balance!.set(data);
      return true;
    }

    return false;
  }

  /// update a repeated balance
  /// specify time if changeType != RepeatableChangeType.all
  /// resetEndTime, endTime are no available for RepeatableChangeType.thisAndAllBefore
  /// RepeatableChangeType.thisAndAllBefore and RepeatableChangeType.thisAndAllAfter will split the repeated balance to 2
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
    Timestamp? newTime,
  }) async {
    // get Data
    final Map<String, dynamic>? data = await _getData();
    if (data == null) {
      return false;
    }

    // update and upload
    if (repeatedBalanceDataManager.updateRepeatedBalanceInData(
      id: id,
      changeType: changeType,
      data: data,
      amount: amount,
      category: category,
      currency: currency,
      name: name,
      initialTime: initialTime,
      repeatDuration: repeatDuration,
      repeatDurationType: repeatDurationType,
      endTime: endTime,
      resetEndTime: resetEndTime,
      time: time,
      newTime: newTime,
    )) {
      await _balance!.set(data);
      return true;
    }

    return false;
  }

  /// [id] is the id of the repeatedBalance
  /// [removeType] decides what data should be removed from the balanceData. RemoveType.none should only be used for repeatedData with endDate
  /// [time] is required if you want to use RemoveType.allBefore or RemoveType.allAfter
  Future<bool> removeRepeatedBalanceUsingId({
    required String id,
    required RepeatableChangeType removeType,
    Timestamp? time,
  }) async {
    // get Data
    final Map<String, dynamic>? data = await _getData();
    if (data == null) {
      return false;
    }

    // remove and upload
    if (repeatedBalanceDataManager.removeRepeatedBalanceFromData(
      id: id,
      data: data,
      removeType: removeType,
      time: time,
    )) {
      await _balance!.set(data);
      return true;
    }

    return false;
  }

  /// it is an alias for removeRepeatedBalanceUsingId with that repeatBalanceData.id
  Future<bool> removeRepeatedBalance({
    required RepeatedBalanceData repeatBalanceData,
    required RepeatableChangeType removeType,
    Timestamp? time,
  }) async {
    return removeRepeatedBalanceUsingId(
      id: repeatBalanceData.id,
      removeType: removeType,
      time: time,
    );
  }

  // Fill in data

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillListViewWithData(
    BalanceDataListView blistview, {
    required BuildContext context,
  }) {
    return balanceDataStreamBuilderManager.fillListViewWithData(
      algorithmProvider: _algorithmProvider,
      blistview: blistview,
      context: context,
      dataStream: _dataStream,
      repeatedBalanceDataManager: repeatedBalanceDataManager,
    );
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillStatisticPanelWithData(
    AbstractHomeScreenCard statisticPanel,
  ) {
    return balanceDataStreamBuilderManager.fillStatisticPanelWithData(
      algorithmProvider: _algorithmProvider,
      dataStream: _dataStream,
      repeatedBalanceDataManager: repeatedBalanceDataManager,
      statisticPanel: statisticPanel,
    );
  }

  // Dispose

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
// TODO: Refactor
