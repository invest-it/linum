import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/widgets/abstract/abstract_statistic_panel.dart';

class HomeScreenCard extends StatelessWidget implements AbstractStatisticPanel {
  num balance = 0;
  num income = 0;
  num expense = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: proportionateScreenWidth(345),
            height: proportionateScreenHeight(196),
            color: Colors.grey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Aktueller Kontostand',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      // TODO make the fake buttons actual buttons, OR add some gestureFields for interaction
                      '< November 2021 >',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      balance.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text('\€', style: Theme.of(context).textTheme.bodyText1)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_upward_rounded,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EINNAHMEN',
                                style: Theme.of(context)
                                    .textTheme
                                    .overline!
                                    .copyWith(fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('\€' + income.toStringAsFixed(2),
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_downward_rounded,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AUSGABEN',
                                style: Theme.of(context)
                                    .textTheme
                                    .overline!
                                    .copyWith(fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('\€' + expense.toStringAsFixed(2),
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  addStatisticData(StatisticsCalculations? statData) {
    if (statData != null) {
      income = statData.sumIncomes;
      expense = statData.sumCosts;
      balance = statData.sumBalance;
      // log('Income:' +
      //     income.toString() +
      //     ' Expense:' +
      //     expense.toString() +
      //     ' Balance:' +
      //     balance.toString());
    }
  }

  @override
  Widget get returnWidget => this;
}
