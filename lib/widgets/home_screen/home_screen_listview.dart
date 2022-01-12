// ignore_for_file: implementation_imports

import 'dart:developer';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/screens/enter_screen.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:linum/widgets/budget_screen/time_widget.dart';
import 'package:provider/provider.dart';

class HomeScreenListView implements BalanceDataListView {
  late ListView _listview;

  HomeScreenListView() {
    _listview = new ListView();
  }

  List<Map<String, dynamic>> _timeWidgets = [
    {
      "widget": TimeWidget(displayValue: 'Heute'),
      "time": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: 1, microseconds: -1))
    },
    {
      "widget": TimeWidget(displayValue: 'Gestern'),
      "time": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(days: 0, microseconds: 1))
    },
    {
      "widget": TimeWidget(displayValue: 'Letzte Woche'),
      "time": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(days: 1, microseconds: 1))
    },
    {
      "widget": TimeWidget(displayValue: 'Diesen Monat'),
      "time": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(days: 7, microseconds: 1))
    },
    {
      "widget": TimeWidget(displayValue: 'Älter'),
      "time": DateTime(DateTime.now().year, DateTime.now().month)
          .subtract(Duration(days: 0, microseconds: 1))
    },
  ];

  @override
  void setBalanceData(List<dynamic> balanceData,
      {required BuildContext context}) {
    initializeDateFormatting();
    DateFormat formatter = DateFormat('EEEE, dd. MMMM yyyy', 'de');

    // remember last used index in the list
    int currentIndex = 0;

    log(_timeWidgets.toString());

    //log(balanceData.toString());
    List<Widget> list = [];
    if (balanceData[0] != null && balanceData[0]["Error"] == null) {
      balanceData.forEach(
        (arrayElement) {
          DateTime date = arrayElement["time"].toDate() as DateTime;
          if (currentIndex < _timeWidgets.length &&
              date.isBefore(_timeWidgets[currentIndex]["time"])) {
            while (currentIndex < (_timeWidgets.length - 1) &&
                date.isBefore(_timeWidgets[currentIndex + 1]["time"])) {
              currentIndex++;
            }

            list.add(_timeWidgets[currentIndex]["widget"]);

            currentIndex++;
          }

          list.add(
            GestureDetector(
              onTap: () {
                BalanceDataProvider balanceDataProvider =
                    Provider.of<BalanceDataProvider>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (innerContext) {
                      return MultiProvider(
                        providers: [
                          ChangeNotifierProvider<EnterScreenProvider>(
                            create: (_) {
                              return EnterScreenProvider();
                            },
                          ),
                          ChangeNotifierProvider<BalanceDataProvider>(
                            create: (_) {
                              return balanceDataProvider..dontDisposeOneTime();
                            },
                          ),
                        ],
                        child: EnterScreen(),
                      );
                    },
                  ),
                );
              },
              //print(arrayElement["amount"].toString()),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Text(
                    arrayElement["category"]
                        .substring(0,
                            Math.min<num>(3, arrayElement["category"].length))
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.overline?.copyWith(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 12,
                        ),
                  ),
                ),
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
