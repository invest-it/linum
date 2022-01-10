// ignore_for_file: implementation_imports

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeScreenListView implements BalanceDataListView {
  late ListView _listview;

  HomeScreenListView() {
    _listview = new ListView();
  }

  @override
  addBalanceData(List<dynamic> balanceData, {required BuildContext context}) {
    initializeDateFormatting();
    DateFormat formatter = DateFormat('EEEE, dd. MMMM yyyy', 'de');
    //log(balanceData.toString());
    List<Widget> list = [];
    if (balanceData[0] != null && balanceData[0]["Error"] == null) {
      balanceData.forEach(
        (arrayElement) {
          list.add(
            GestureDetector(
              onTap: () => print(arrayElement["amount"].toString()),
              child: ListTile(
                title: Text(
                  arrayElement["name"],
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  formatter
                      .format(
                        arrayElement["time"].toDate(),
                      )
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.overline,
                ),
                trailing: Text(
                  arrayElement["amount"].toStringAsFixed(2) + "€",
                  style: arrayElement["amount"] < 0
                      ? Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Theme.of(context).colorScheme.error)
                      : Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                ),
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
