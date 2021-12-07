// ignore_for_file: implementation_imports

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/scroll_view.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';

class TestListView implements BalanceDataListView {
  late ListView _listview;

  TestListView() {
    log("Creating TestListView");
    _listview = new ListView();
  }

  @override
  addBalanceData(List<dynamic> balanceData) {
    log("log addBalanceData");
    if (balanceData[0] != "Error") {
      log(balanceData.toString());
    } else {
      log("Error");
    }
  }

  @override
  ListView get listview => _listview;
}
