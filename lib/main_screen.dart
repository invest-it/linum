import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          balance.add({"singleBalance": "Second Test Text"});
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
          notchMargin: 5,
          shape: CircularNotchedRectangle(),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.ac_unit_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.dashboard_customize),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.aspect_ratio),
              ),
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      backgroundColor: Colors.white,
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            );
            /*ListView(
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
    );
  }
}
