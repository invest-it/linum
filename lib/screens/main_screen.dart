import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/widgets/fab.dart';
import 'package:linum/widgets/home_screen_card.dart';
import 'package:linum/widgets/test_implementation.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    required this.title,
    required this.monthlyBudget,
  }) : super(key: key);

  final String title;
  final double monthlyBudget;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    CollectionReference balance =
        FirebaseFirestore.instance.collection('balance');

    BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: balance.snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.zero,
                        bottom: Radius.circular(40),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.20,
                        color: createMaterialColor(
                          Color(0xFF82B915),
                        ),
                      ),
                    ),
                  ],
                ),
                HomeScreenCard(monthlyBudget: 4.20),
                balanceDataProvider.fillListViewWithData(TestListView()),
              ],
            );

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
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        elevation: 2.0,
        backgroundColor: createMaterialColor(
          Color(0xFF505050),
        ),
      ),
      bottomNavigationBar: FABBottomAppBar(
        items: [
          BottomAppBarItem(iconData: Icons.home, text: 'Home'),
          BottomAppBarItem(iconData: Icons.book, text: 'Statistics'),
          BottomAppBarItem(iconData: Icons.account_balance, text: 'Budget'),
          BottomAppBarItem(iconData: Icons.account_box, text: 'Account'),
        ],
        backgroundColor: createMaterialColor(
          Color(0xFF82B915),
        ),
        centerItemText: '',
        color: createMaterialColor(
          Color(0xFFF0F0F0),
        ),
        selectedColor: createMaterialColor(
          Color(0xFF505050),
        ),
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: (int value) {},
      ),
    );
  }
}
