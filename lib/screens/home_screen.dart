import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/widgets/home_screen/home_screen_card.dart';
import 'package:linum/widgets/home_screen/home_screen_listview.dart';

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //the top, green lip
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.zero,
                bottom: Radius.circular(40),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.20,
                // TODO change this into a sustainable and responsive design

                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            //placeholder --> covers exactly the space that the HomeScreenCard covers
            //give it a different color to see it's effect
            Container(
              height: MediaQuery.of(context).size.height * 0.19,
              color: Theme.of(context).colorScheme.background,
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
                    "Mehr",
                    style: Theme.of(context).textTheme.bodyText2,
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
        Positioned(
          top: 30,
          left: 50,
          right: 50,
          child: Column(
            children: [
              Text("Home", style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
        //where the balance is shown to the user
        HomeScreenCard(
          balance: 4.20,
          income: 10.00,
          expense: 5.80,
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
