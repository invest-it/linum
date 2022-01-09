import 'package:flutter/material.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/widgets/home_screen/home_screen_card.dart';
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
    BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    return Stack(
      children: <Widget>[
        ScreenSkeleton(
          head: 'Home',
          isInverted: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              HomeScreenCard(
                balance: 1081.46,
                income: 1200.00,
                expense: 1200 - 1081.46,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Neueste Transaktionen",
                        style: Theme.of(context).textTheme.headline5),
                    Text(
                      "MEHR",
                      style: Theme.of(context).textTheme.overline?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
/* ListView(
                children: snapshot.data == null
                    ? [Text("Error")]
                    : snapshot.data!.docs.map((singleBalance) {
                        return ListTile(
                          title:
                              Text(singleBalance["singleBalance"].toString()),
                          onLongPress: () {
                            singleBalance.reference.delete();
                          },
                        );
                      }).toList());*/
