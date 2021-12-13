// ignore_for_file: implementation_imports

import 'dart:developer';

import 'package:flutter/src/widgets/scroll_view.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';

class TestListView implements BalanceDataListView {
  late ListView _listview;

  TestListView() {
    _listview = new ListView();
  }

  @override
  addBalanceData(List<dynamic> balanceData) {
    if (balanceData[0] != null && balanceData[0]["Error"] != null) {
      balanceData.forEach((arrayElement) {
        arrayElement.forEach((key, element) {
          if (key == "name") {
            // log("key:  " + key);
            // log("value: " + element.toString());
          }
        });
      });
    } else {
      log("TestListView: " + balanceData[0]["Error"].toString());
    }
  }

  @override
  ListView get listview => _listview;
}
