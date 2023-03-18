//  Balance Data Provider - Provider that handles all operations upon a single (or multiple) BalanceData
//
//  Author: SoTBurst
//  Co-Author: n/a //TODO @SoTBurst this is also rather a critical file that might need more trained people
//  tored)

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/utils/balance_data_stream_builder.dart';
import 'package:linum/core/balance/utils/serial_transaction_manager.dart';
import 'package:linum/core/balance/utils/statistical_calculations.dart';
import 'package:linum/core/balance/utils/transaction_manager.dart';
import 'package:linum/core/balance/widgets/balance_data_list_view.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:linum/features/currencies/services/exchange_rate_service.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Provides the balance data from the database using the uid.
class BalanceDataService extends ChangeNotifier {
  /// _balance is the documentReference to get the balance data from the database. It will be null if the constructor isnt ready yet
  firestore.DocumentReference<BalanceDocument>? _balance;

  /// The uid of the user
  late String _uid;

  final Logger logger = Logger();

  late AlgorithmService _algorithmProvider;
  late ExchangeRateService _exchangeRateProvider;
  late BalanceDataStreamBuilder _streamBuilder;
  // Manager

  /// Creates the BalanceDataProvider. Inparticular it sets [_balance] correctly
  BalanceDataService(BuildContext context) {
    _uid = Provider.of<AuthenticationService>(context, listen: false).uid;
    _algorithmProvider = Provider.of<AlgorithmService>(context, listen: false);
    _exchangeRateProvider =
        Provider.of<ExchangeRateService>(context, listen: false);
    _streamBuilder =
        BalanceDataStreamBuilder(_algorithmProvider, _exchangeRateProvider);
    asyncConstructor();
  }

  /// Async part of the constructor (so notifyListeners will be used after loading)
  Future<void> asyncConstructor() async {
    if (_uid == "") {
      return;
    }
    final firestore.DocumentSnapshot<Map<String, dynamic>> documentToUser =
        await firestore.FirebaseFirestore.instance
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
        logger.e("error getting doc id");
        return;
      }
      if (docs.isEmpty) {
        docs = await _createDoc();
      }

      // Future support multiple docs per user
      _balance = firestore.FirebaseFirestore.instance
          .collection('balance')
          .withConverter<BalanceDocument>(
            fromFirestore: (snapshot, _) =>
                BalanceDocument.fromMap(snapshot.data()!),
            toFirestore: (doc, _) => doc.toMap(),
          )
          .doc(docs[0] as String);
      notifyListeners();
    } else {
      logger.wtf("no data found in documentToUser");
    }
  }

  /// Creates Document if it doesn't exist
  Future<List<dynamic>> _createDoc() async {
    logger.i("creating document");
    final firestore.DocumentSnapshot<Map<String, dynamic>> doc = await firestore
        .FirebaseFirestore.instance
        .collection('balance')
        .doc("documentToUser")
        .get();
    final Map<String, dynamic>? docData = doc.data();
    Map<String, dynamic> docDataNullSafe = {};
    if (docData != null) {
      docDataNullSafe = docData;
    }

    final firestore.DocumentReference<Map<String, dynamic>> ref =
        await firestore.FirebaseFirestore.instance.collection('balance').add({
      "balanceData": [],
      "repeatedBalance": [],
      "settings": {},
    });

    await firestore.FirebaseFirestore.instance
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
      asyncConstructor();
    }
  }

  /// update [_algorithmProvider] if it is new. redo the document connections
  void updateAlgorithmProvider(AlgorithmService? algorithm) {
    if (algorithm != null &&
        (_algorithmProvider != algorithm ||
            _algorithmProvider.balanceNeedsNotice)) {
      _algorithmProvider = algorithm;
      _algorithmProvider.balanceDataNotice();
      // notifyListeners(); // Called during update,
      // which already notifies its listeners
    }
  }

  /// update [_exchangeRateProvider].
  void updateExchangeRateProvider(ExchangeRateService provider) {
    _exchangeRateProvider = provider;
  }

  /// Get the document-datastream. Maybe in the future it might be a public function
  Stream<firestore.DocumentSnapshot<BalanceDocument>>? get _dataStream {
    return _balance?.snapshots();
  }

  /// add a single Balance and upload it
  Future<bool> addTransaction(Transaction transaction) async {
    // get Data
    final data = await _getData();
    if (data == null) {
      return false;
    }

    // add and upload
    if (TransactionManager.addTransactionToData(transaction, data)) {
      await _balance!.set(data);
      return true;
    }

    logger.e("couldn't add single balance");
    return false;
  }

  /// update a single Balance and upload it (identified using the name and time)
  Future<bool> updateTransactionDirectly({
    required String id,
    num? amount,
    String? category,
    String? currency,
    String? name,
    firestore.Timestamp? time,
  }) async {
    // get Data
    final data = await _getData();
    if (data == null) {
      return false;
    }

    // update and upload
    if (TransactionManager.updateTransactionInData(
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

    await _balance!
        .update(data.toMap()); // TODO: Check this out, sounds crazy, right?
    return true;
  }

  Future<bool> updateTransaction(
    Transaction transaction,
  ) async {
    return updateTransactionDirectly(
      id: transaction.id,
      amount: transaction.amount,
      category: transaction.category,
      currency: transaction.currency,
      name: transaction.name,
      time: transaction.time,
    );
  }

  /// remove a single Balance and upload it (identified using id)
  Future<bool> removeTransactionUsingId(String id) async {
    // get Data
    final data = await _getData();
    if (data == null) {
      return false;
    }

    // remove and upload
    if (TransactionManager.removeTransactionFromData(id, data)) {
      await _balance!.set(data);
      return true;
    }

    logger.e("couldn't remove single balance");
    return false;
  }

  /// it is an alias for removeSingleBalanceUsingId(singleBalance.id);
  Future<bool> removeTransaction(Transaction transaction) {
    return removeTransactionUsingId(transaction.id);
  }

  Future<BalanceDocument?> _getData() async {
    // check connection
    if (_balance == null) {
      logger.e("_balance is null");
      return null;
    }

    // get data
    final firestore.DocumentSnapshot<BalanceDocument> snapshot =
        await _balance!.get();
    final BalanceDocument? data = snapshot.data();

    // check if data exists
    if (data == null) {
      logger.e("Corrupted User Document");
      return null;
    }

    return data;
  }

  /// add a repeated Balance and upload it (the stream will automatically show it in the app again)
  Future<bool> addSerialTransaction(
    SerialTransaction serialTransaction,
  ) async {
    // get Data
    final data = await _getData();
    if (data == null) {
      return false;
    }

    // add and upload
    if (SerialTransactionManager.addSerialTransactionToData(
      serialTransaction,
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
  Future<bool> updateSerialTransaction({
    required String id,
    required SerialTransactionChangeType changeType,
    num? amount,
    String? category,
    String? currency,
    String? name,
    firestore.Timestamp? initialTime,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    firestore.Timestamp? endTime,
    bool resetEndTime = false,
    firestore.Timestamp? time,
    firestore.Timestamp? newTime,
  }) async {
    // get Data
    final data = await _getData();
    if (data == null) {
      return false;
    }

    // update and upload
    if (SerialTransactionManager.updateSerialTransactionInData(
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
  Future<bool> removeSerialTransactionUsingId({
    required String id,
    required SerialTransactionChangeType removeType,
    firestore.Timestamp? time,
  }) async {
    // get Data
    final data = await _getData();
    if (data == null) {
      return false;
    }

    // remove and upload
    if (SerialTransactionManager.removeSerialTransactionFromData(
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

  /// it is an alias for removeRepeatedBalanceUsingId with that serialTransaction.id
  Future<bool> removeSerialTransaction({
    required SerialTransaction serialTransaction,
    required SerialTransactionChangeType removeType,
    firestore.Timestamp? time,
  }) async {
    return removeSerialTransactionUsingId(
      id: serialTransaction.id,
      removeType: removeType,
      time: time,
    );
  }

  // Fill in data

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillListViewWithData(
    BalanceDataListView listView, {
    required BuildContext context,
  }) {
    return _streamBuilder.fillListViewWithData(
      listView: listView,
      context: context,
      dataStream: _dataStream,
    );
  }

  StreamBuilder fillListViewWithRepeatables(
    BalanceDataListView blistview, {
    required BuildContext context,
  }) {
    return _streamBuilder.fillListViewWithData(
      listView: blistview,
      context: context,
      dataStream: _dataStream,
      isSerial: true,
    );
  }

  Stream<StatisticalCalculations>? getStatisticalCalculations() {
    return _streamBuilder.getStatisticCalculations(dataStream: _dataStream);
  }

  // Settings

  /// upload one setting as map
  Future<void> uploadSettings(Map<String, dynamic> settings) async {
    if (_balance == null) {
      logger.e("_balance is null");
    }
    final snapshot = await _balance!.get();
    final data = snapshot.data();
    data!.settings = settings;
    await _balance!.set(data);
  }

  /// get settings as map
  Future<Map<String, dynamic>> getSettings() async {
    if (_balance == null) {
      logger.e("_balance is null");
    }
    final snapshot = await _balance!.get(); // TODO: WILD
    final data = snapshot.data();
    return data!.settings;
  }

}
// TODO: Refactor
