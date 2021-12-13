import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:provider/provider.dart';

class BalanceDataProvider extends ChangeNotifier {
  DocumentReference<Map<String, dynamic>>? _balance;
  late String uid;

  BalanceDataProvider(BuildContext ctx) {
    uid = Provider.of<AuthenticationService>(ctx).uid;
    FirebaseFirestore.instance
        .collection('balance')
        .doc("documentToUser")
        .get()
        .then((documentToUser) {
      if (documentToUser.exists) {
        Map<String, dynamic>? data = documentToUser.data();
        List<String> docs = data?[uid];
        _balance =
            FirebaseFirestore.instance.collection('balance').doc(docs[0]);
      } else {
        log("Error couldn't find 'documentToUser'");
      }
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? get _dataStream {
    return _balance?.snapshots();
  }

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
