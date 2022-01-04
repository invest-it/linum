// ignore_for_file: implementation_imports

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';

class HomeScreenListView implements BalanceDataListView {
  late ListView _listview;

  HomeScreenListView() {
    _listview = new ListView();
  }

  @override
  addBalanceData(List<dynamic> balanceData) {
    log(balanceData.toString());
    List<Widget> list = [];
    if (balanceData[0] != null && balanceData[0]["Error"] == null) {
      balanceData.forEach(
        (arrayElement) {
          list.add(
            GestureDetector(
              onTap: () => print(arrayElement["amount"].toString()),
              child: ListTile(
                title: Text(arrayElement["name"]),
                subtitle: Text((arrayElement["time"].toDate()).toString()),
                trailing: Text(arrayElement["amount"].toString() + "€"),
              ),
            ),
          );
        },
      );
    } else {
      log("HomeScreenListView: " + balanceData[0]["Error"].toString());
    }
    _listview = ListView(children: list);
  }

  @override
  ListView get listview => _listview;
}
