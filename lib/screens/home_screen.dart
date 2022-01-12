import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/widgets/home_screen/home_screen_listview.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenIndexProvider screenIndexProvider =
        Provider.of<ScreenIndexProvider>(context);

    BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);

    algorithmProvider.setCurrentFilterAlgorithm(
        AlgorithmProvider.olderThan(Timestamp.fromDate(DateTime.now())));

    return ScreenSkeleton(
      head: 'Home',
      isInverted: true,
      hasHomeScreenCard: true,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 25, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text("Neueste Transaktionen",
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    TextButton(
                      onPressed: () => screenIndexProvider.setPageIndex(1),
                      child: Text(
                        "MEHR",
                        style: Theme.of(context).textTheme.overline?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: balanceDataProvider.fillListViewWithData(
                    HomeScreenListView(),
                    context: context,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
