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
    balanceData.forEach((value) {
      log(value.toString());
    });
  }

  @override
  ListView get listview => _listview;
}
