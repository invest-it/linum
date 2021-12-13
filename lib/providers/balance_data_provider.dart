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
    FirebaseFirestore.instance
        .collection('balance')
        .doc("documentToUser")
        .get()
        .then((documentToUser) {
      if (documentToUser.exists) {
        log(documentToUser.toString());
        Map<String, dynamic>? data = documentToUser.data();
        log(data == null ? data.toString() : "data is null");
        if (data != null) {
          List<String>? docs = data[_uid];
          log("docs: " + docs.toString());
          if (docs != null) {
            // TODO: Future support multiple docs per user
            _balance =
                FirebaseFirestore.instance.collection('balance').doc(docs[0]);
          } else {
            log("no docs found for user: " + _uid);
          }
        } else {
          log("no data found in documentToUser");
        }
      } else {
        log("Error couldn't find 'documentToUser'");
      }
    });
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
          blistview.addBalanceData(["Error"]);
          return blistview.listview;
        } else {
          blistview.addBalanceData(
              snapshot.data!.docs.map((doc) => doc.data()).toList());
          return blistview.listview;
        }
      },
    );
  }
}
