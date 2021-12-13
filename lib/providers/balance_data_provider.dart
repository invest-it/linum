import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/abstract/abstract_statistic_panel.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:provider/provider.dart';

/// Provides the balance data from the database using the uid.
class BalanceDataProvider extends ChangeNotifier {
  /// _balance is the documentReference to get the balance data from the database. It will be null if the constructor isnt ready yet
  DocumentReference<Map<String, dynamic>>? _balance;

  /// The uid of the user
  late String _uid;

  late final AlgorithmProvider _algorithmProvider;

  /// Creates the BalanceDataProvider. Inparticular it sets [_balance] correctly
  BalanceDataProvider(BuildContext context) {
    _uid = Provider.of<AuthenticationService>(context, listen: false).uid;
    _algorithmProvider = Provider.of<AlgorithmProvider>(context, listen: false);
    asynConstructor();
  }

  /// Async part of the constructor (so notifyListeners will be used after loading)
  asynConstructor() async {
    DocumentSnapshot<Map<String, dynamic>> documentToUser =
        await FirebaseFirestore.instance
            .collection('balance')
            .doc("documentToUser")
            .get();
    if (documentToUser.exists) {
      List<dynamic>? docs = documentToUser.get(_uid);
      if (docs != null) {
        // Future support multiple docs per user
        _balance =
            FirebaseFirestore.instance.collection('balance').doc(docs[0]);
        notifyListeners();
      } else {
        log("no docs found for user: " + _uid);
      }
    } else {
      log("no data found in documentToUser");
    }
  }

  /// Get the document-datastream. Maybe in the future it might be a public function
  Stream<DocumentSnapshot<Map<String, dynamic>>>? get _dataStream {
    return _balance?.snapshots();
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillListViewWithData(BalanceDataListView blistview) {
    return StreamBuilder(
      stream: _dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          blistview.addBalanceData([
            {"Error": "snapshot.data == null"}
          ]);
          return blistview.listview;
        } else {
          List<dynamic> balanceData = snapshot.data["balanceData"];
          // Future there could be an sort algorithm provider
          // (and possibly also a filter algorithm provided)
          balanceData.sort(_algorithmProvider.currentSorter);
          balanceData.removeWhere(_algorithmProvider.currentFilter);
          blistview.addBalanceData(balanceData);
          return blistview.listview;
        }
      },
    );
  }

  /// Returns a StreamBuilder that builds the ListView from the document-datastream
  StreamBuilder fillStatisticPanelWithData(
      AbstractStatisticPanel statisticPanel) {
    return StreamBuilder(
      stream: _dataStream,
      builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          statisticPanel.addStatisticData({"Error": "snapshot.data == null"});
          return statisticPanel.widget;
        } else {
          List<dynamic> balanceData = snapshot.data["balanceData"];
          balanceData.removeWhere(_algorithmProvider.currentFilter);
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(balanceData as List<Map<String, dynamic>>);
          statisticPanel.addStatisticData({
            "sum": statisticsCalculations.sum,
            "averageCost": statisticsCalculations.averageCost,
          });
          return statisticPanel.widget;
        }
      },
    );
  }

  /// add a single Balance and upload it
  void addSingleBalance({
    required num amount,
    required String category,
    required String currency,
    required String name,
    required Timestamp time,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return;
    }
    Map<String, dynamic> singleBalance = {
      "amount": amount,
      "category": category,
      "currency": currency,
      "name": name,
      "time": time,
    };
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    data["balanceData"].add(singleBalance);
    _balance!.set(data);
  }

  /// remove a single Balance and upload it (identified using the name and time)
  Future<bool> removeSingleBalance({
    required String name,
    required Timestamp time,
  }) async {
    if (_balance == null) {
      log("_balance is null");
      return false;
    }

    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    int dataLength = data["balanceData"].length;
    data["balanceData"].removeWhere((value) {
      return value["name"] == name && value["time"] == time;
    });
    if (dataLength > data["balanceData"].length) {
      _balance!.set(data);
      return true;
    }
    return false;
  }

  /// update a single Balance and upload it (identified using the name and time)
  Future<bool> updateSingleBalance({
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
    bool isEdited = false;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _balance!.get();
    dynamic data = snapshot.data();
    List<dynamic> ff;
    data["balanceData"].forEach((value) {
      if (value["name"] == name && value["time"] == time) {
        isEdited = !(value["amount"] == amount &&
            value["category"] == category &&
            value["currency"] == currency);
        if (isEdited) {
          value["amount"] = amount;
          value["category"] = category;
          value["currency"] = currency;
        }
      }
    });
    if (isEdited) {
      _balance!.set(data);
    }
    return isEdited;
  }
}
