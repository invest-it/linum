import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/widgets/fab.dart';
import 'package:linum/widgets/test_implementation.dart';

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
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: balance.snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Container(); /*Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            );
            floatingActionButton: FloatingActionButton(
        onPressed: () {
          balance.add({"singleBalance": "Second Test Text"});
        },
        child: Icon(Icons.add),
      ),
            ListView(
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
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: FABBottomAppBar(
        items: [
          BottomAppBarItem(iconData: Icons.menu, text: 'This'),
          BottomAppBarItem(iconData: Icons.layers, text: 'Is'),
          BottomAppBarItem(iconData: Icons.dashboard, text: 'Bottom'),
          BottomAppBarItem(iconData: Icons.info, text: 'Bar'),
        ],
        backgroundColor: createMaterialColor(
          Color(0xFF82B915),
        ),
        centerItemText: '',
        color: createMaterialColor(
          Color(0xFFF0F0F0),
        ),
        selectedColor: Colors.black,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: (int value) {},
      ),
    );
  }
}
