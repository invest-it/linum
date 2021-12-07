import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';

class BalanceDataProvider extends ChangeNotifier {
  late CollectionReference _balance;

  BalanceDataProvider() {
    log("created new BalanceDataProvider");
    _balance = FirebaseFirestore.instance.collection('balance');
  }

  Stream<QuerySnapshot<Object?>> get dataStream {
    return _balance.snapshots();
  }

  StreamBuilder fillListViewWithData(BalanceDataListView blistview) {
    log("fillListViewWithData");
    return StreamBuilder(
      stream: dataStream,
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
