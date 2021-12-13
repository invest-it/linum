import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:provider/provider.dart';

/// Provides the balance data from the database using the uid.
class BalanceDataProvider extends ChangeNotifier {
  /// _balance is the documentReference to get the balance data from the database. It will be null if the constructor isnt ready yet
  DocumentReference<Map<String, dynamic>>? _balance;

  /// The uid of the user
  late String _uid;

  /// Creates the BalanceDataProvider. Inparticular it sets [_balance] correctly
  BalanceDataProvider(BuildContext ctx) {
    _uid = Provider.of<AuthenticationService>(ctx, listen: false).uid;
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
            {
              "Error": "snapshot.data == null",
            }
          ]);
          return blistview.listview;
        } else {
          List<dynamic> balanceData = snapshot.data["balanceData"];
          // Future there could be an sort algorithm provider
          // (and possibly also a filter algorithm provided)
          balanceData.sort((a, b) => a["time"].compareTo(b["time"]));
          blistview.addBalanceData(balanceData);
          return blistview.listview;
        }
      },
    );
  }
}
