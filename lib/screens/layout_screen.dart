import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/screens/budget_screen.dart';
import 'package:linum/screens/enter_screen.dart';
import 'package:linum/screens/home_screen.dart';
import 'package:linum/screens/settings_screen.dart';
import 'package:linum/screens/statistics_screen.dart';
import 'package:linum/widgets/bottom_app_bar.dart';
import 'package:provider/provider.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({
    Key? key,
    required this.title,
    required this.monthlyBudget,
  }) : super(key: key);

  final String title;
  final double monthlyBudget;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    CollectionReference balance =
        FirebaseFirestore.instance.collection('balance');

    BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    //list with all the "screens"
    List<Widget> _page = <Widget>[
      HomeScreen(),
      StatisticsScreen(),
      BudgetScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: balance.snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            //returns the page at the current index
            return _page.elementAt(pageIndex);
          },
        ),
      ),
      //floatingactionbutton with bottomnavbar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Timestamp time = Timestamp.fromDate(DateTime.now());
          // balanceDataProvider.addSingleBalance(
          //   amount: -5.24,
          //   category: "food",
          //   currency: "EUR",
          //   name: "Fast Food Menu",
          //   time: time,
          // );
          // Future.delayed(const Duration(seconds: 2), () {}).then((_) {
          //   balanceDataProvider
          //       .updateSingleBalance(
          //     amount: -5.48,
          //     category: "food",
          //     currency: "EUR",
          //     name: "Fast Food Menu",
          //     time: time,
          //   )
          //       .then((_) {
          //     Future.delayed(const Duration(seconds: 2), () {}).then((_) {
          //       balanceDataProvider.removeSingleBalance(
          //           name: "Fast Food Menu", time: time);
          //     });
          //   });
          // });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnterScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        elevation: 2.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      bottomNavigationBar: FABBottomAppBar(
        items: [
          BottomAppBarItem(iconData: Icons.home, text: 'Home'),
          BottomAppBarItem(iconData: Icons.savings_rounded, text: 'Budget'),
          BottomAppBarItem(iconData: Icons.bar_chart_rounded, text: 'Stats'),
          BottomAppBarItem(iconData: Icons.person, text: 'Account'),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerItemText: '',
        color: Theme.of(context).colorScheme.background,
        selectedColor: Theme.of(context).colorScheme.secondary,
        notchedShape: CircularNotchedRectangle(),
        //gives the pageIndex the value (the current selected index in the
        //bottom navigation bar)
        onTabSelected: (int value) {
          setState(() {
            pageIndex = value;
          });
        },
      ),
    );
  }
}
